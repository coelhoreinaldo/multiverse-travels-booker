require "kemal"
require "json"
require "../../config/config"

class ValidateBody < Kemal::Handler
  only ["/travel_plans"], "POST"
  only ["/travel_plans/:id"], "PUT"

  def call(env)
    return call_next(env) unless only_match?(env)
    body = env.params.json

    if body.empty? || body["travel_stops"].as(Array).empty?
      env.response.status_code = 400
      error = {message: "you must provide a list of travel stops"}.to_json
      env.response.content_type = "application/json"
      env.response.print error
    else
      call_next(env)
    end
  end
end

add_handler ValidateBody.new
