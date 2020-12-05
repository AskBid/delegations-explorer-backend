require 'net/http'
require 'uri'
require 'json'
require 'resolv-replace'

puts 'querying graphql server (#query_graphql)'

uri = URI.parse("http://81.149.31.222:3100")
request = Net::HTTP::Post.new(uri)
# request.read_timeout = 5

request.content_type = "application/json"
request["Accept"] = "application/json"
request["Connection"] = "keep-alive"
request["Dnt"] = "1"
request["Origin"] = "http://81.149.31.222:3100"

obj = {"query": "{activeStake_aggregate(where: {epochNo: {_eq: 230}}) {aggregate {count}}}"}

request.body = JSON.dump(obj)

req_options = {
  use_ssl: uri.scheme == "https",
  read_timeout: 5
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end
# puts response.code
puts JSON.parse(response.body)['data']