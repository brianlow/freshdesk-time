# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'activesupport'
  gem 'color'
  gem 'faraday'
  gem 'faraday_middleware'
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
require 'faraday'
require 'faraday_middleware'
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
PDF_FOLDER = CSV_FOLDER
SQUAD_NAME = 'Trop Rock'
month = Date.current.beginning_of_month

# Export
csv_name = "#{CSV_FOLDER}/#{month.strftime('%Y-%m')}.csv"
puts "Exporting time to #{pastel.green(csv_name)}"
script = File.read('timing_csv.applescript.template')
script = script.sub(/==FROM_DATE==/, month.beginning_of_month.beginning_of_day.strftime('%A, %B %e, %Y at %I:%M %p'))
script = script.sub(/==TO_DATE==/, month.end_of_month.end_of_day.strftime('%A, %B %e, %Y at %I:%M %p'))
script = script.sub(/==FILENAME==/, csv_name)
Tempfile.open do |f|
  f.write(script)
  f.flush
  f.close
  `osascript #{f.path}`
  raise "osascript failed #{$?}" if $? != 0
end

# Read CSV output by Timing App
puts 'Reading csv'
csv = TimingCsv.new.parse(csv_name)
hours_by_date = csv.map { |row| [row.date, round(row.hours)] }.to_h
total_hours = csv.sum(&:hours)
puts "Found #{csv.count} rows and #{pastel.white("#{total_hours} hours")}"

# Create sheet
sheet_name = month.strftime('%b %Y')
spreadsheet = GoogleSpreadsheet.new(spreadsheet_id)
if spreadsheet.sheet_exists?(sheet_name)
  puts "Spreadsheet #{pastel.green(spreadsheet.title)} already has sheet #{pastel.green(sheet_name)}"
else
  puts "Creating sheet #{pastel.green(sheet_name)} in spreadsheet #{pastel.green(spreadsheet.title)}"
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

pdf = "#{PDF_FOLDER}/#{month.strftime('%Y-%m')}.pdf"
puts "Downloading PDF to #{pastel.green(pdf)}"
spreadsheet.download_pdf(sheet_name, pdf)

puts "Sheet: #{spreadsheet.link_to_sheet(sheet_name)}"

puts ''
