require 'net/http'
require 'json'

uri = URI('https://www.kimonolabs.com/api/dmzo8lei?apikey=6caa957c418cd29064574897317dc6d8')
youtube_hash = Hash.new()

#SCHEDULER.every '5m' do
SCHEDULER.every '1m' do
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') { |http|
        request = Net::HTTP::Get.new uri
        response = http.request request
        youtube_hash = JSON.parse(response.body);
        send_event('youtubetrends', { items: youtube_hash['results']['collection1'], name: youtube_hash['name'], frequency: youtube_hash['frequency'] })
    }
end