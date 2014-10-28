require 'net/http'
require 'json'

uri = URI('https://www.kimonolabs.com/api/5pelyzn8?apikey=VGJ0nMhw7BsmCGs7UqxW8CuUW2B5Xoac')
google_search_hash = Hash.new()

#SCHEDULER.every '5m' do
SCHEDULER.every '1m' do
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') { |http|
        request = Net::HTTP::Get.new uri
        response = http.request request
        google_search_hash = JSON.parse(response.body);
        
        # rename key 'property1' to 'Trends' to make the widget reusable
        google_search_hash['results']['collection1'].each {|x| 
            x['Trends'] = x['property1']
            x.delete('property1')
        }

        # 'google_search_trends' --> 'Google Search Trends'
        google_search_hash['name'].gsub!('_', ' ')
        google_search_hash['name'] = google_search_hash['name'].split.map(&:capitalize).join(' ')

        send_event('googlesearchtrends', { items: google_search_hash['results']['collection1'], name: google_search_hash['name'], frequency: google_search_hash['frequency'] })
    }
end