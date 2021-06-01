# frozen_string_literal: true

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
  gem 'google-api-client'
  gem 'pry-byebug'
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
require 'google/apis/sheets_v4'
require 'googleauth'
require 'fileutils'

require_relative 'google_spreadsheet'
require_relative 'timing_csv'
require_relative 'timesheet'

def round(hours)
  (hours * 2.0).round / 2.0
end

pastel = Pastel.new
puts ''

spreadsheet_id = '17Z7EGb2AFZiMRL2JC0abEdrCY1klXod2tWWTM98q3j8' # Temp Spreadsheet
CSV_FOLDER = '/Users/brianshift/Downloads/time'
SQUAD_NAME = 'Trop Rock'
month = Date.current.beginning_of_month

# Read CSV output by Timing App
csv_name = "#{CSV_FOLDER}/#{month.strftime('%Y-%m')}.csv"
puts "Reading #{pastel.green(csv_name)}"
csv = TimingCsv.new.parse(csv_name)
hours_by_date = csv.map { |row| [row.date, round(row.hours)] }.to_h
total_hours = csv.sum(&:hours)
puts "Found #{csv.count} rows and #{pastel.white("#{total_hours} hours")}"

sheet_name = month.strftime('%b %Y')
spreadsheet = GoogleSpreadsheet.new(spreadsheet_id)
if spreadsheet.sheet_exists?(sheet_name)
  puts "Sheet #{pastel.green(sheet_name)} exists"
else
  puts "Creating sheet #{pastel.green(sheet_name)} from template"
  spreadsheet.duplicate_sheet('Template', sheet_name)
  spreadsheet.set_cell(sheet_name, 'C3', "Period: #{sheet_name}")
end

puts 'Setting cells'
values =
  (month..(month.end_of_month)).map do |date|
    hours = hours_by_date[date]
    [date.iso8601, hours || '', hours.present? ? SQUAD_NAME : '']
  end
spreadsheet.set_cells(sheet_name, 'A6:C36', values)
recorded_hours = spreadsheet.cell(sheet_name, 'B37')
puts "Recorded #{pastel.white("#{recorded_hours} hours")}"

puts ''
