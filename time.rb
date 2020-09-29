require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'tty-table'
  gem 'faraday'
  gem 'pastel'
  gem 'rainbow'
  gem 'color'
  gem 'activesupport'
  gem 'pry'
end

require 'json'
require 'date'
require 'time'
require 'pastel'
require 'rainbow'
require 'color'
require 'csv'
require 'ostruct'
require 'pry'
require 'active_support/all'
require_relative 'freshdesk'
require_relative 'timing_csv'
require_relative 'printer'

api_key = ENV['APIKEY']
agent_id = ENV['AGENTID'].to_i

freshdesk = Freshdesk.new(api_key, agent_id)
filename = '/Users/brianmeta/Downloads/All Activities.csv'


actual = freshdesk.list_time_entries

expected = TimingCsv.new.parse(filename)
expected.each do |exp|
  unless freshdesk.tickets_by_subject.key?(exp.ticket_subject)
    raise "Cannot find ticket with subject #{exp.ticket_subject}"
  end

  ticket = freshdesk.tickets_by_subject[exp.ticket_subject]
  exp.ticket_id = ticket.id
  exp.ticket_color = ticket.color
end

date_range = Range.new(
  expected.map(&:date).min,
  expected.map(&:date).max
)

actual = actual.filter { |entry| date_range.cover?(entry.date) }

def missing(set1, set2, operation)
  set1
    .filter do |entry1|
      set2.none?{ |entry2| key(entry1) == key(entry2) }
    end
    .map do |entry|
      entry[:operation] = operation
      entry
    end
end

def same(set1, set2, operation)
  set1
    .filter do |entry1|
      set2.any?{ |entry2| key(entry1) == key(entry2) }
    end
    .map do |entry|
      entry[:operation] = operation
      entry
    end
end

def key(entry)
  [entry.date, entry.ticket_id, entry.duration, entry.note]
end

# TODO: will not delete a duplicate
diff = missing(actual, expected, :delete) + missing(expected, actual, :create) + same(actual, expected, :nothing)
diff = diff.sort_by { |entry| "#{entry.date.iso8601}-#{entry.ticket_subject}-#{entry.operation == :delete ? '1' : '0'}" }.reverse

puts "Agent #{agent_id}"
puts "Period #{date_range}"
puts ''

Printer.new.print_entries(diff)

if ENV['SAVE']
  puts ''
  diff.each do |entry|
    if entry.operation == :create
      puts "Creating #{entry.date} for #{entry.ticket_subject}"
      freshdesk.create_time_entry(entry)
    end
    if entry.operation == :delete
      puts "Deleting #{entry.date} for #{entry.ticket_subject}"
      freshdesk.delete_time_entry(entry)
    end
  end
end
