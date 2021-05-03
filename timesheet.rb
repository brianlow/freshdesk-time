class Timesheet
  def initialize(entries)
    @entries = entries
    @date_range = entries.first.date.beginning_of_month..entries.first.date.end_of_month
  end

  def print
    @date_range.each do |date|
      entry = @entries.find { |e| e.date == date }
      if entry
        puts "#{entry.date.iso8601},#{entry.hours},Trop Rock"
      else
        puts "#{date.iso8601},,"
      end
    end

    total = @entries.map(&:hours).sum
    puts "Total;#{total}"
  end
end
