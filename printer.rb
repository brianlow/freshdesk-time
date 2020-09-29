class Printer
  def print_entries(entries)
    rows = entries.map do |entry|
      [
        format_operation(entry[:operation]),
        entry.date.strftime('%a, %b %-d %Y'),
        Rainbow(format_duration(entry.duration)).white,
        Rainbow(entry.ticket_subject).color(entry.ticket_color),
        entry.note
      ]
    end

    headers = ['', 'Date', 'Duration', 'Ticket', 'Note']
    separators = headers.map { |h| '─' * h.length }
    table = TTY::Table.new headers, [separators] + rows

    puts ''
    puts table.render(:basic, padding: [0, 2, 0, 0], resize: true)
    puts ''
  end

  def format_duration(minutes)
    s = Time.at(minutes * 60).utc.strftime("%H:%M")
    return "  #{s[2..]}" if s.starts_with?("00")
    return " #{s[1..]}" if s.starts_with?("0")
    s
  end

  def format_operation(op)
    return Rainbow("+").green if op == :create
    return Rainbow("-").red if op == :delete
    nil
  end
end
