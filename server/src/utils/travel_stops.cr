require "http/client"
require "json"

def get_travel_stops(travel_stops)
  api_url = "https://rickandmortyapi.com/api/location/"

  travel_stops.each do |id|
    if id == travel_stops.last
      api_url += "#{id}"
      break
    end
    api_url += "#{id},"
  end

  api_response = HTTP::Client.get api_url
  if api_response.status == HTTP::Status::OK
    parsed_data = JSON.parse(api_response.body)
    travel_stops = Array(NamedTuple(id: Int32, name: String, dimension: String, type: String)).from_json(api_response.body)
    return travel_stops
  else
    return nil
  end
end
