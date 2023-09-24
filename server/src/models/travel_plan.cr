class TravelPlan < Jennifer::Model::Base
  mapping(
    id: {type: Primary64},
    travel_stops: {type: String?},
  )
end
