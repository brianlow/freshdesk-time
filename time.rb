require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'activesupport'
  gem 'color'
  gem 'faraday'
  gem 'pastel'
  gem 'pry'
  gem 'rainbow'
  gem 'tty-table'
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
require_relative 'timing_csv'
require_relative 'timesheet'

filename = ARGV[0]

entries = TimingCsv.new.parse(filename)

Timesheet.new(entries).print
