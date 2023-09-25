require "http/client"
require "json"

def get_travel_stop(id)
  api_response = HTTP::Client.get "https://rickandmortyapi.com/api/location/#{id}"
  if api_response.status == HTTP::Status::OK
    parsed_data = JSON.parse(api_response.body)

    travel_stop = {
      id:        parsed_data["id"].as_i,
      name:      parsed_data["name"].as_s,
      type:      parsed_data["type"].as_s,
      dimension: parsed_data["dimension"].as_s,
    }
    return travel_stop
  else
    return nil
  end
end

def get_all_travel_stops(travel_stops)
  result = [] of NamedTuple(id: Int32, name: String, type: String, dimension: String)
  travel_stops.each do |id|
    travel_stop = get_travel_stop(id)
    result << travel_stop if travel_stop
  end
  return result
end
