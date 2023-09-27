require "../services/travel_plan_service"

module App
  VERSION = "0.1.0"

  before_all "*" do |env|
    env.response.content_type = "application/json"
  end

  TRAVEL_PLAN_SERVICE = TravelPlanService.new

  post "/travel_plans" do |env|
    travel_stops = env.params.json["travel_stops"].as(Array)

    if travel_stops.size == 0
      error = {message: "travel_stops was not provided"}.to_json
      halt env, status_code: 400, response: error
    end

    created_travel_plan = TRAVEL_PLAN_SERVICE.create_travel_plan(travel_stops)
    env.response.status_code = 201
    created_travel_plan.to_json
  end

  get "/travel_plans" do |env|
    expand = env.params.query["expand"]? == "true"
    optimize = env.params.query["optimize"]? == "true"

    travel_plans = TRAVEL_PLAN_SERVICE.get_all_travel_plans(expand: expand, optimize: optimize)
    env.response.status_code = 200
    travel_plans.to_json
  end

  get "/travel_plans/:id" do |env|
    id = env.params.url["id"].to_i
    expand = env.params.query["expand"]?
    optimize = env.params.query["optimize"]?

    found_travel_plan = TRAVEL_PLAN_SERVICE.get_travel_plan_by_id(id, expand: expand, optimize: optimize)
    env.response.status_code = 200
    found_travel_plan.to_json
  end

  put "/travel_plans/:id" do |env|
    id = env.params.url["id"].to_i
    travel_stops = env.params.json["travel_stops"].as(Array)

    if travel_stops.size == 0
      error = {message: "travel_stops was not provided"}.to_json
      halt env, status_code: 400, response: error
    end

    stringified_array = travel_stops.to_s

    updated_travel_plan = TravelPlan.where { _id == id }.update(travel_stops: stringified_array)

    updated_travel_response = {
      id:           id,
      travel_stops: Array(Int64).from_json(stringified_array),
    }
    env.response.status_code = 200
    updated_travel_response.to_json
  end

  delete "/travel_plans/:id" do |env|
    id = env.params.url["id"].to_i
    TravelPlan.delete(id)

    env.response.status_code = 204
  end

  patch "/travel_plans/:id/append" do |env|
    id = env.params.url["id"].to_i
    new_travel_stop = env.params.json["travel_stop"].as(Int64)

    travel_exists = TravelPlan.find(id)

    parsed_response = NamedTuple(id: Int32, travel_stops: String).from_json(travel_exists.to_json)
    parsed_travel_stops = Array(Int64).from_json(parsed_response["travel_stops"])

    parsed_travel_stops << new_travel_stop
    stringified_array = parsed_travel_stops.to_s

    updated_travel_plan = TravelPlan.where { _id == id }.update(travel_stops: stringified_array)

    updated_travel_response = {
      id:           id,
      travel_stops: Array(Int64).from_json(stringified_array),
    }

    env.response.status_code = 200
    updated_travel_response.to_json
  end
end
