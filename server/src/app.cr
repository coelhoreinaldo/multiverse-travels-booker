require "kemal"

module App
  VERSION = "0.1.0"
  get "/travel_plans" do
    person = {first_name: "Reinaldo", last_name: "XD"}
    person.to_json
  end

  post "/travel_plans/:id" do |context|
    id = context.params.url["id"]?
    first_name = context.params.body["first_name"]?
    last_name = context.params.body["last_name"]?

    if !first_name
      error = {message: "first_name was not provided"}.to_json
      halt context, status_code: 403, response: error
    end
    {person: "Person with name #{first_name} #{last_name} and id #{id}"}.to_json
  end
end

Kemal.run
