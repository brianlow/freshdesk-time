class TimingCsv
  #
  # Parses a CSV from Timing.app returning an enumerable
  # of OpenStruct rows with these attributes:
  #   date            (date)
  #   duration        (integer, in minutes)
  #   ticket_subject  (string)
  #   note            (string)
  #
  def parse(filename)
    CSV
      .read(filename, headers: true)
      .map do |row|
        OpenStruct.new(
          {
            date: Date.parse(row['Day']),
            ticket_subject: project_to_ticket(row['Project']&.strip),
            task: parse_task(row['Task Title'].presence&.strip),
            duration: parse_duration(row['Duration'])
          }
        )
      end
      .group_by { |row| [row.date, row.ticket_subject]}
      .map do |key, rows|
        OpenStruct.new(
          {
            date: key[0],
            duration: round_down_to_5min(rows.map(&:duration).reduce(0, :+)),
            ticket_subject: key[1],
            note: rows.map(&:task).compact.join(', ')
          }
        )
      end
      .reject { |entry| entry.duration < 5 }
      .reject { |entry| entry.ticket_subject == 'Other' }
  end

  def parse_task(task)
    if task == '(Entries shorter than 1m each)'
      nil
    else
      task
    end
  end

  def parse_duration(duration)
    (Time.parse(duration).seconds_since_midnight / 60).floor.to_i
  end

  def round_down_to_5min(duration)
    ((duration / 5.0).floor * 5).to_i
  end

  def project_to_ticket(project)
    return 'Metaverse Development & QA' if project == 'Cross Collateralization'

    project
  end
end
