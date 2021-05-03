class TimingCsv
  #
  # Parses a CSV from Timing.app returning an enumerable
  # of OpenStruct rows with these attributes:
  #   date            (date)
  #   hours           (fractional hours)
  #
  def parse(filename)
    CSV
      .read(filename, headers: true)
      .map do |row|
        OpenStruct.new(
          {
            date: Date.parse(row['Day']),
            hours: parse_duration(row['Duration'])
          }
        )
      end
      .reject { |entry| entry.hours < (5 / 60.0) }
  end

  def parse_duration(duration)
    Float(duration)
  end
end
