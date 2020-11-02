# Freshdesk Time Entry from CSV

### Setup
Setup two environment variables
* `APIKEY` - Freshdesk -> Profile -> "Your API Key" in top right
* `AGENTID` - Freshdesk -> Profile -> your numeric id is in the URL

### To use
1. Record your time in a CSV:

    ```
    Day,Project,Duration,Task Title
    2020-09-01,My Freshdesk Ticket Name,0:30:00,Built a cool feature
    2020-09-02,My Freshdesk Ticket Name,1:20:00,Some other feature
    ```
    * Project - name of your Freshdesk Ticket, rows with "Other" will be ignored
    * Duration - HH:MM:SS format
    * Multiple rows for the same date and project will be combined automatically
2. To see a diff
    ```
    ruby time.rb mytime.csv
    ```
3. To save to Freshdesk
    ```
    SAVE=true ruby time.rb mytime.csv
    ```

To print out a semi-colon-separated version of the timeshet (suitable for copy-paste
into Google Sheets) run with `TIMESHEET=true`

### Gotcha/Limitations
* Can only handle Projects that you already have at least one time entry on
  (need to figure out how to query projects by name)
* Won't delete duplicates from Freshdesk
  (need to improve diff algo)
