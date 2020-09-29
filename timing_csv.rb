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
            project: row['Project'],
            task: parse_task(row['Task Title'].presence),
            duration: parse_duration(row['Duration'])
          }
        )
      end
      .group_by { |row| [row.date, row.project]}
      .map do |key, rows|
        OpenStruct.new(
          {
            date: key[0],
            duration: rows.map(&:duration).reduce(0, :+),
            ticket_subject: key[1],
            note: rows.map(&:task).compact.join(', ')
          }
        )
      end
      .reject { |row| row.duration < 5 }
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
end
