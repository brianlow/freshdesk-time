# frozen_string_literal: true

class GoogleDrive
  APPLICATION_NAME = 'Ruby Timesheet'
  CREDENTIALS_PATH = 'service-credentials.json'
  SCOPE = Google::Apis::DriveV3::AUTH_DRIVE

  def upload(local_file, drive_folder_id, content_type)
    metadata = Google::Apis::DriveV3::File.new(name: File.basename(local_file), parents: [drive_folder_id])
    service.create_file(metadata, upload_source: local_file, content_type: content_type)
  end

  private

  def service
    @service ||= build_service
  end

  def build_service
    service = Google::Apis::DriveV3::DriveService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(CREDENTIALS_PATH),
      scope: SCOPE
    )
    service.authorization.fetch_access_token!
    service
  end
end
