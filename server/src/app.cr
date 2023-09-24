require "kemal"
require "../config/config"
require "json"

module App
  VERSION = "0.1.0"
  get "/locations" do
    locations = Location.all
    locations.to_json
  end

  post "/locations" do |context|
    name = context.params.body["name"]?
    type = context.params.body["type"]?
    dimension = context.params.body["dimension"]?
    Location.create({name: name, type: type, dimension: dimension})
  end

  post "/travel_plans" do |env|
    env.response.content_type = "application/json"
    travel_plan = env.params.json

    if !travel_plan
      error = {message: "travel_stops was not provided"}.to_json
      halt env, status_code: 403, response: error
    end
    stringified_array = travel_plan["travel_stops"].to_s

    created_travel_plan = TravelPlan.create({travel_stops: stringified_array})

    response = {
      travel_stops: Array(Int64).from_json(stringified_array),
      id:           created_travel_plan.id,
    }
    response.to_json
  end

  get "/travel_plans" do |env|
    env.response.content_type = "application/json"
    travel_plans = TravelPlan.all
    travel_plans.to_json
  end
end

Kemal.run
