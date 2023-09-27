require "kemal"
require "json"
require "../../config/config"

class ValidateTravelPlan < Kemal::Handler
  exclude ["/travel_plans"], "POST"
  exclude ["/travel_plans"], "GET"

  def call(env)
    return call_next(env) if exclude_match?(env)
    id = env.params.url["id"].to_i
    travel_plan_exists = TravelPlan.find(id)

    if !travel_plan_exists
      env.response.status_code = 404
      error = {message: "travel_plan with id #{id} not found"}.to_json
      env.response.content_type = "application/json"
      env.response.print error
    else
      call_next(env)
    end
  end
end

add_handler ValidateTravelPlan.new
