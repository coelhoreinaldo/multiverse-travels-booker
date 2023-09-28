require "../services/travel_plan_service"

module App
  VERSION = "0.1.0"

  before_all "*" do |env|
    env.response.content_type = "application/json"
  end

  TRAVEL_PLAN_SERVICE = TravelPlanService.new

  post "/travel_plans" do |env|
    travel_stops = env.params.json["travel_stops"].as(Array)

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

    updated_travel = TRAVEL_PLAN_SERVICE.update_travel_plan(id, travel_stops)
    env.response.status_code = 200
    updated_travel.to_json
  end

  delete "/travel_plans/:id" do |env|
    id = env.params.url["id"].to_i
    TravelPlan.delete(id)

    env.response.status_code = 204
  end

  patch "/travel_plans/:id/append" do |env|
    id = env.params.url["id"].to_i
    new_travel_stop = env.params.json["travel_stop"].as(Int64)

    updated_travel = TRAVEL_PLAN_SERVICE.append_travel_stop(id, new_travel_stop)
    env.response.status_code = 200
    updated_travel.to_json
  end
end
