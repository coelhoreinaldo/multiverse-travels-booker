require "kemal"
require "../config/config"
require "json"
require "./utils/travel_stops"
require "./middleware/validate_travel_plan"
require "./middleware/validate_body"
require "./controllers/travel_plan_controller"

Kemal.config.port = ENV["PORT"].to_i || 3000

Kemal.run
