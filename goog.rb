# frozen_string_literal: true

class Goog
  APPLICATION_NAME = 'Ruby Timesheet'
  CREDENTIALS_PATH = 'service-credentials.json'
  SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

  def self.sheets
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
