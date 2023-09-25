require "kemal"
require "../config/config"
require "json"
require "./utils/travel_stops"

module App
  VERSION = "0.1.0"

  post "/travel_plans" do |env|
    env.response.content_type = "application/json"
    travel_stops = env.params.json["travel_stops"].as(Array)
    if travel_stops.size == 0
      error = {message: "travel_stops was not provided"}.to_json
      halt env, status_code: 403, response: error
    end

    stringified_array = travel_stops.to_s

    created_travel_plan = TravelPlan.create({travel_stops: stringified_array})

    created_travel_response = {
      id:           created_travel_plan.id,
      travel_stops: Array(Int64).from_json(stringified_array),
    }
    env.response.status_code = 201
    created_travel_response.to_json
  end

  get "/travel_plans" do |env|
    env.response.content_type = "application/json"
    expand = env.params.query["expand"]?
    travel_plans = TravelPlan.all

    parsed_response = Array(NamedTuple(id: Int32, travel_stops: String)).from_json(travel_plans.to_json)
    travel_plans_response = parsed_response.map do |t|
      parsed_travel_stops = Array(Int64).from_json(t["travel_stops"])
      t_travel_stops = parsed_travel_stops

      if expand == "true"
        t_travel_stops = get_all_travel_stops(parsed_travel_stops)
      end

      {"id" => t["id"], "travel_stops" => t_travel_stops}
    end

    env.response.status_code = 200
    travel_plans_response.to_json
  end

  get "/travel_plans/:id" do |env|
    env.response.content_type = "application/json"
    id = env.params.url["id"].to_i
    expand = env.params.query["expand"]?
    travel_plan = TravelPlan.find(id)

    if !travel_plan
      error = {message: "travel_plan with id #{id} not found"}.to_json
      halt env, status_code: 404, response: error
    end

    parsed_response = NamedTuple(id: Int32, travel_stops: String).from_json(travel_plan.to_json)
    formatted_response = {
      "id"           => parsed_response["id"],
      "travel_stops" => if expand == "true"
        get_all_travel_stops(Array(Int64).from_json(parsed_response["travel_stops"]))
      else
        Array(Int64).from_json(parsed_response["travel_stops"])
      end,
    }

    env.response.status_code = 200
    formatted_response.to_json
  end
end

Kemal.run
