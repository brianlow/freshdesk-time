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

def format_duration(minutes)
  s = Time.at(minutes * 60).utc.strftime("%H:%M")
  return "  #{s[2..]}" if s.starts_with?("00")
  return " #{s[1..]}" if s.starts_with?("0")
  s
end

def print_entries(entries)
  rows = entries.map do |entry|
    pp entry
    [
      entry[:operation]&.to_s,
      entry.date.strftime('%a, %b %-d %Y'),
      Rainbow(format_duration(entry.duration)).white,
      Rainbow(entry.ticket_subject).color(entry.ticket_color),
      entry.note
    ]
  end

  headers = ['', 'Date', 'Duration', 'Ticket', 'Note']
  separators = headers.map { |h| '─' * h.length }
  table = TTY::Table.new headers, [separators] + rows

  puts ''
  puts table.render(:basic, padding: [0, 2, 0, 0])
  puts ''
end

api_key = ENV['APIKEY']
agent_id = ENV['AGENTID'].to_i

freshdesk = Freshdesk.new(api_key, agent_id)
actual = freshdesk.list_time_entries
print_entries(actual)


filename = '/Users/brianmeta/Downloads/All Activities.csv'
expected = TimingCsv.new.parse(filename)

expected.each do |exp|
  if !freshdesk.tickets_by_subject.has_key?(exp.ticket_subject)
    raise "Cannot find ticket with subject #{exp.ticket_subject}"
  end

  ticket = freshdesk.tickets_by_subject[exp.ticket_subject]
  exp.ticket_id = ticket.id
  exp.ticket_color = ticket.color
end
print_entries(expected)

def missing(set1, set2, operation)
  set1.filter do |entry1|
    set2.none?{ |entry2| key(entry1) == key(entry2) }
  end
  .map do |entry|
    entry[:operation] = operation
    entry
  end
end

def same(set1, set2, operation)
  set1.filter do |entry1|
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
diff = diff.sort_by{ |entry| "#{entry.date.iso8601}-#{entry.ticket_subject}" }.reverse

pp diff
print_entries(diff)

# diff.each do |entry|
#   if entry.operation == :create
#     freshdesk.create_time_entry(entry)
#   end
# end
