require "kemal"
require "json"
require "../../config/config"

class ValidatePostPutBody < Kemal::Handler
  only ["/travel_plans"], "POST"
  only ["/travel_plans/:id"], "PUT"

  def call(env)
    return call_next(env) unless only_match?(env)
    begin
      body = env.params.json

      if body.empty? || body["travel_stops"].as(Array).empty?
        env.response.status_code = 400
        error = {message: "you must provide a list of travel stops"}.to_json
        env.response.content_type = "application/json"
        env.response.print error
      else
        call_next(env)
      end
    rescue exception
      env.response.status_code = 400
      error = {message: "you must provide a list of integers"}.to_json
      env.response.content_type = "application/json"
      env.response.print error
    end
  end
end

add_handler ValidatePostPutBody.new

class ValidatePatchBody < Kemal::Handler
  only ["/travel_plans/:id/append"], "PATCH"

  def call(env)
    return call_next(env) unless only_match?(env)
    begin
      body = env.params.json

      if body.empty?
        env.response.status_code = 400
        error = {message: "you must provide an integer travel stop"}.to_json
        env.response.content_type = "application/json"
        env.response.print error
      else
        call_next(env)
      end
    rescue exception
      env.response.status_code = 400
      error = {message: "you must provide an integer travel stop"}.to_json
      env.response.content_type = "application/json"
      env.response.print error
    end
  end
end

add_handler ValidatePatchBody.new
