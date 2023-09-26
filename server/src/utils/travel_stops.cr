require "http/client"
require "json"

API_URL = "https://rickandmortyapi.com/graphql"

def get_travel_stops(travel_stops, expand = false, optimize = false)
  query = "
  query {
    locationsByIds(ids: #{travel_stops}){
      id
      name
      dimension
      type
      residents {
        episode {
          characters {
            id
          }
        }
      }
    }
  }
  "

  data = {
    "query" => query,
  }.to_json

  headers = HTTP::Headers{"Content-Type" => "application/json"}
  api_response = HTTP::Client.post(API_URL, headers: headers, body: data)

  if api_response.status == HTTP::Status::OK
    parsed_data = JSON.parse(api_response.body)["data"]["locationsByIds"]
    travel_stops = Array(NamedTuple(id: String, name: String, dimension: String, type: String, residents: Array(NamedTuple(episode: Array(NamedTuple(characters: Array(Hash(String, String)))))))).from_json(parsed_data.to_json)

    sorted_by_popularity = travel_stops.sort_by { |stop| stop["residents"].map { |resident| resident["episode"].map { |episode| episode["characters"].size }.sum }.sum }

    if optimize == "true" && expand == "true"
      sorted_by_dimension = sorted_by_popularity.sort_by { |stop| stop["dimension"] }
      return sorted_by_dimension.map { |stop| {id: stop["id"].to_i, name: stop["name"], dimension: stop["dimension"], type: stop["type"]} }
    end

    if expand == "true"
      return travel_stops.map { |stop| {id: stop["id"].to_i, name: stop["name"], dimension: stop["dimension"], type: stop["type"]} }
    end

    if optimize == "true"
      sorted_by_dimension = sorted_by_popularity.sort_by { |stop| stop["dimension"] }
      return sorted_by_dimension.map { |stop| stop["id"].to_i }
    end
    return travel_stops.map { |stop| stop["id"].to_i }
  else
    return nil
  end
end
