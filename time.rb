require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'tty-table'
  gem 'faraday'
  gem 'pastel'
  gem 'rainbow'
  gem 'color'
  gem 'activesupport'
end

require 'json'
require 'date'
require 'time'
require 'pastel'
require 'rainbow'
require 'color'
require 'csv'
require 'active_support/all'
require_relative 'freshdesk'
require_relative 'timing_csv'

def format_duration(minutes)
  s = Time.at(minutes * 60).utc.strftime("%H:%M")
  return "  #{s[2..]}" if s.starts_with?("00")
  return " #{s[1..]}" if s.starts_with?("0")
  s
end

api_key = ENV['APIKEY']
agent_id = ENV['AGENTID']

freshdesk = Freshdesk.new(api_key, agent_id)
entries = freshdesk.list_time_entries

rows = entries.map do |entry|
  [
    entry.date.strftime('%a, %b %-d %Y'),
    Rainbow(format_duration(entry.duration)).white,
    Rainbow(entry.ticket_subject).color(entry.ticket_color),
    entry.note
  ]
end

headers = ['Date', 'Duration', 'Ticket', 'Note']
separators = headers.map { |h| '─' * h.length }
table = TTY::Table.new headers, [separators] + rows

puts ''
puts table.render(:basic, padding: [0, 2, 0, 0])
puts ''

filename = '/Users/brianmeta/Downloads/All Activities.csv'
puts TimingCsv.new.parse(filename)
