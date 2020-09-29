class Freshdesk
  def initialize(api_key, agent_id)
    @api_key = api_key
    @agent_id = agent_id
  end

  #
  # Retrieves time entries from Freshdesk and returns an enumerable
  # of OpenStruct rows with these attributes:
  #   date            (date)
  #   duration        (integer, in minutes)
  #   ticket_id       (string)
  #   ticket_subject  (string)
  #   ticket_color    (symbol)
  #   note            (string)
  #
  def list_time_entries
    conn = Faraday.new(url: 'https://metacomet.freshdesk.com') do |c|
      c.response :raise_error
      c.basic_auth(@api_key, 'x')
      c.adapter :net_http
    end

    results = JSON.parse(conn.get('/api/v2/time_entries', { agent_id: @agent_id }).body)

    hue_start = 200
    hue_incr = 50
    sat = 65
    lightness = 50

    @tickets_by_id =
      results
      .map { |res| res['ticket_id'] }
      .uniq
      .map { |ticket_id| JSON.parse(conn.get("/api/v2/tickets/#{ticket_id}").body) }
      .map.with_index do |res, i|
        [
            res['id'],
            OpenStruct.new(
              {
                id: res['id'],
                subject: res['subject'],
                color: Color::HSL.new((hue_start + (i * hue_incr)) % 360, sat, lightness).to_rgb.html
              }
            )
        ]
      end
      .to_h

    results.map do |res|
      ticket = @tickets_by_id[res['ticket_id']]
      OpenStruct.new(
        {
          date: Date.parse(res['executed_at']),
          duration: parse_duration(res['time_spent']),
          ticket_id: res['ticket_id'],
          ticket_subject: ticket.subject,
          ticket_color: ticket.color,
          note: res['note']
        }
      )
    end
  end

  def tickets_by_id
    @tickets_by_id
  end

  def tickets_by_subject
    @tickets_by_subject =
      tickets_by_id
      .values
      .map { |ticket| [ticket.subject, ticket] }
      .to_h
  end

  def parse_duration(duration)
    (Time.parse("#{duration}:00").seconds_since_midnight / 60).floor.to_i
  end
end
