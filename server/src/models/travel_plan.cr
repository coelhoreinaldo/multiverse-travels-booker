# require "json"

class TravelPlan < Jennifer::Model::Base
  # include JSON::Serializable

  mapping(
    id: {type: Primary64},
    travel_stops: {type: String?},
  )
end
