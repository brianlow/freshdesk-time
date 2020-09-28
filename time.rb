require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'tty-table'
  gem 'faraday'
  gem 'pastel'
  gem 'rainbow'
  gem 'color'
end

require 'json'
require 'date'
require 'pastel'
require 'rainbow'
require 'color'

api_key = ENV['APIKEY']
agent_id = ENV['AGENTID']

conn = Faraday.new(url: 'https://metacomet.freshdesk.com') do |c|
  c.response :raise_error
  c.basic_auth(api_key, 'x')
  c.adapter :net_http
end

results = JSON.parse(conn.get('/api/v2/time_entries', { agent_id: agent_id }).body)

hue_start = 200
hue_incr = 50
sat = 65
lightness = 50

tickets =
  results
  .map { |res| res['ticket_id'] }
  .uniq
  .map { |ticket_id| JSON.parse(conn.get("/api/v2/tickets/#{ticket_id}").body) }
  .map.with_index { |res, i| [res['id'], { subject: res['subject'], color: Color::HSL.new((hue_start + (i * hue_incr)) % 360, sat, lightness).to_rgb.html} ] }
  .to_h

entries = results.map do |res|
  ticket = tickets[res['ticket_id']]
  [
    Date.parse(res['executed_at']).strftime('%a, %b %-d %Y'),
    Rainbow(res['time_spent']).white,
    Rainbow(ticket[:subject]).color(ticket[:color]),
    res['note']
  ]
end

headers = ['Date', 'Time', 'Project', 'Note']
separators = headers.map { |h| '─' * h.length }
table = TTY::Table.new headers, [separators] + entries

puts ''
puts table.render(:basic, padding: [0, 2, 0, 0])
puts ''
