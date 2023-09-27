class TravelPlanService
  def create_travel_plan(travel_stops)
    stringified_array = travel_stops.to_s
    created_travel_plan = TravelPlan.create({travel_stops: stringified_array})

    created_travel_response = {
      id:           created_travel_plan.id,
      travel_stops: Array(Int64).from_json(stringified_array),
    }
    return created_travel_response
  end
end
