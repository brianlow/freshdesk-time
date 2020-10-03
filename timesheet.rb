class Timesheet
  def initialize(entries)
    @entries = group_by_day(entries)
    @date_range = entries.first.date.beginning_of_month..entries.first.date.end_of_month
  end

  def print
    @date_range.each do |date|
      entry = @entries.find { |e| e.date == date }
      if entry
        puts "#{entry.date.iso8601};#{entry.duration / 60.0};#{entry.note}"
      else
        puts "#{date.iso8601};;"
      end
    end

    total = @entries.map(&:duration).reduce(0, :+)
    puts "Total;#{total/60.0}"
  end

  private

  def group_by_day(entries)
    entries
      .group_by(&:date)
      .map do |key, rows|
        OpenStruct.new(
          {
            date: key,
            duration: rows.map(&:duration).reduce(0, :+),
            note: rows.map(&:note).compact.join(', ')
          }
        )
      end
  end

  def format_duration(minutes)
    Time.at(minutes * 60).utc.strftime('%H:%M')
  end
end
