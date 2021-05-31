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
require 'googleauth/stores/file_token_store'
require 'fileutils'

require_relative 'goog'
require_relative 'timing_csv'
require_relative 'timesheet'

spreadsheet_id = '17Z7EGb2AFZiMRL2JC0abEdrCY1klXod2tWWTM98q3j8' # Temp Spreadsheet
csv_folder = '/Users/brianshift/Downloads/time'

month = Date.new(2021, 5, 1)

csv = TimingCsv.new.parse("#{csv_folder}/#{month.strftime('%Y-%m')}.csv")
pp csv

service = Goog.sheets
sheet_name = month.strftime('%b %Y')
spreadsheet = service.get_spreadsheet(spreadsheet_id)
sheet = spreadsheet.sheets.find { |s| s.properties.title == sheet_name }

if sheet.blank?
  template = spreadsheet.sheets.find { |s| s.properties.title == 'Template' }

  duplicate = Google::Apis::SheetsV4::DuplicateSheetRequest.new(
    source_sheet_id: template.properties.sheet_id,
    new_sheet_name: sheet_name,
    insert_sheet_index: 1
  )
  request = Google::Apis::SheetsV4::Request.new(duplicate_sheet: duplicate)
  batch = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(requests: [request])
  service.batch_update_spreadsheet(spreadsheet_id, batch)

  sheet = spreadsheet.sheets.find { |s| s.properties.title == sheet_name }
end

# https://github.com/googleapis/google-api-ruby-client/tree/master/google-api-client/generated/google/apis/sheets_v4
# https://stackoverflow.com/questions/59231487/google-sheets-api-v4-bold-part-of-cell
# https://developers.google.com/sheets/api/samples/formatting

binding.pry
i = 1
# Find sheet

# entries = TimingCsv.new.parse(filename)

# Timesheet.new(entries).print
