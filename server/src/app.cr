require "kemal"
require "../config/config"
require "json"

module App
  VERSION = "0.1.0"
  post "/travel_plans" do |env|
    env.response.content_type = "application/json"
    travel_plan = env.params.json

    if !travel_plan
      error = {message: "travel_stops was not provided"}.to_json
      halt env, status_code: 403, response: error
    end
    stringified_array = travel_plan["travel_stops"].to_s

    created_travel_plan = TravelPlan.create({travel_stops: stringified_array})

    created_travel_response = {
      travel_stops: Array(Int64).from_json(stringified_array),
      id:           created_travel_plan.id,
    }
    env.response.status_code = 201
    created_travel_response.to_json
  end

  get "/travel_plans" do |env|
    env.response.content_type = "application/json"
    travel_plans = TravelPlan.all
    travel_plans_arr = Array(NamedTuple(id: Int32, travel_stops: String)).from_json(travel_plans.to_json)
    travel_plans_response = travel_plans_arr.map do |t|
      t_travel_stops = Array(Int64).from_json(t["travel_stops"])
      {"id" => t["id"], "travel_stops" => t_travel_stops}
    end
    env.response.status_code = 200
    travel_plans_response.to_json
  end
end

Kemal.run
