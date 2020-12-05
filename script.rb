require 'net/http'

url = 'http://81.149.31.222:3100'
mykey = 'demo'
uri = URI(url)

request = Net::HTTP::Get.new(uri.path)
request['Content-Type'] = 'application/xml'
request['Accept'] = 'application/xml'
request['X-OFFERSDB-API-KEY'] = mykey

response = Net::HTTP.new(uri.host,uri.port) do |http|
  http.request(request)
end

puts response