# frozen_string_literal: true

class GoogleSpreadsheet
  APPLICATION_NAME = 'Ruby Timesheet'
  CREDENTIALS_PATH = 'service-credentials.json'
  SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

  def initialize(spreadsheet_id)
    @spreadsheet_id = spreadsheet_id
  end

  def title
    spreadsheet.properties.title
  end

  def sheet_exists?(sheet_name)
    spreadsheet.sheets.any? { |s| s.properties.title == sheet_name }
  end

  def duplicate_sheet(source_sheet, target_sheet)
    template = spreadsheet.sheets.find { |s| s.properties.title == source_sheet }

    duplicate = Google::Apis::SheetsV4::DuplicateSheetRequest.new(
      source_sheet_id: template.properties.sheet_id,
      new_sheet_name: target_sheet,
      insert_sheet_index: 1
    )
    request = Google::Apis::SheetsV4::Request.new(duplicate_sheet: duplicate)
    batch = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(requests: [request])
    service.batch_update_spreadsheet(@spreadsheet_id, batch)
  end

  def set_cell(sheet_name, cell, value)
    service.update_spreadsheet_value(
      @spreadsheet_id,
      "'#{sheet_name}'!#{cell}",
      Google::Apis::SheetsV4::ValueRange.new(values: [[value]]),
      value_input_option: 'USER_ENTERED'
    )
  end

  def set_cells(sheet_name, range, values)
    service.update_spreadsheet_value(
      @spreadsheet_id,
      "'#{sheet_name}'!#{range}",
      Google::Apis::SheetsV4::ValueRange.new(values: values),
      value_input_option: 'USER_ENTERED'
    )
  end

  def cell(sheet_name, cell)
    result = service.get_spreadsheet_values(
      @spreadsheet_id,
      "'#{sheet_name}'!#{cell}"
    )
    result.values.first.first
  end

  def link_to_sheet(sheet_name)
    sheet = spreadsheet.sheets.find { |s| s.properties.title == sheet_name }
    "https://docs.google.com/spreadsheets/d/#{@spreadsheet_id}/edit#gid=#{sheet.properties.sheet_id}"
  end

  def download_pdf(sheet_name, path)
    sheet = spreadsheet.sheets.find { |s| s.properties.title == sheet_name }
    url = "https://docs.google.com/spreadsheets/d/#{@spreadsheet_id}/export"
    params = { gid: sheet.properties.sheet_id, 'exportFormat': 'pdf', range: 'A1:C37' }

    conn = Faraday.new { |f| f.response :follow_redirects }
    response = conn.get(url, params, { 'Authorization' => "Bearer #{service.authorization.access_token}" })
    File.write(path, response.body)
  end

  private

  def spreadsheet
    @spreadsheet ||= service.get_spreadsheet(@spreadsheet_id)
  end

  def service
    @service ||= build_service
  end

  def build_service
    service = Google::Apis::SheetsV4::SheetsService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(CREDENTIALS_PATH),
      scope: SCOPE
    )
    service.authorization.fetch_access_token!
    service
  end
end
