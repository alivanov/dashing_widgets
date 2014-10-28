require 'net/http'
require 'json'

uri = URI('https://www.kimonolabs.com/api/dgr5h3ou?apikey=6caa957c418cd29064574897317dc6d8')
google_plus_hash = Hash.new()

#SCHEDULER.every '5m' do
SCHEDULER.every '1m' do
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') { |http|
        request = Net::HTTP::Get.new uri
        response = http.request request
        google_plus_hash = JSON.parse(response.body);
        send_event('googleplustrends', { items: google_plus_hash['results']['collection1'], name: google_plus_hash['name'], frequency: google_plus_hash['frequency'] })
    }
end