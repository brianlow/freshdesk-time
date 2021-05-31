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

spreadsheet_id = '17Z7EGb2AFZiMRL2JC0abEdrCY1klXod2tWWTM98q3j8' # Temp Spreadsheet
csv_folder = '/Users/brianshift/Downloads/time'

month = Date.new(2021, 5, 1)

csv = TimingCsv.new.parse("#{csv_folder}/#{month.strftime('%Y-%m')}.csv")
hours_by_date = csv.map { |row| [row.date, round(row.hours)] }.to_h

sheet_name = month.strftime('%b %Y')
spreadsheet = GoogleSpreadsheet.new(spreadsheet_id)
spreadsheet.duplicate_sheet('Template', sheet_name) unless spreadsheet.sheet_exists?(sheet_name)
spreadsheet.set_cell(sheet_name, 'B6', 'Hey')

# https://github.com/googleapis/google-api-ruby-client/tree/master/google-api-client/generated/google/apis/sheets_v4
# https://stackoverflow.com/questions/59231487/google-sheets-api-v4-bold-part-of-cell
# https://developers.google.com/sheets/api/samples/formatting

# Find sheet

# entries = TimingCsv.new.parse(filename)

# Timesheet.new(entries).print

binding.pry
i = 0
