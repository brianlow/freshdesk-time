# Timing App -> format for Google Sheet invoice

### Setup

* https://console.cloud.google.com -> IAM -> Service Accounts
* Project: Ruby Timesheet
* Service: Ruby Timesheet Service
* Keys -> Create New Key
* Save to `service-credentials.json`
* In particular a Google Sheet -> Share with the service account email

### To Run
```
ruby time.rb
```

### Todo

- handle shorter months (delete last row, get total hours, pdf range)
- externalize env vars
- download_url doesn't work on newly created sheet
- bold the month headre
