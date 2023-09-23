require "kemal"
require "../config/config"

module App
  VERSION = "0.1.0"
  # get "/travel_plans" do
  #   person = {first_name: "Reinaldo", last_name: "Coelho"}
  #   person.to_json
  # end

  # post "/travel_plans/:id" do |context|
  #   id = context.params.url["id"]?
  #   first_name = context.params.body["first_name"]?
  #   last_name = context.params.body["last_name"]?

  #   if !first_name
  #     error = {message: "first_name was not provided"}.to_json
  #     halt context, status_code: 403, response: error
  #   end
  #   {person: "Person with name #{first_name} #{last_name} and id #{id}"}.to_json
  # end

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
end

Kemal.run
