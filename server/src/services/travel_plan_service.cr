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

  def get_all_travel_plans(expand, optimize)
    travel_plans = TravelPlan.all

    parsed_response = Array(NamedTuple(id: Int32, travel_stops: String)).from_json(travel_plans.to_json)
    travel_plans_response = parsed_response.map do |t|
      parsed_travel_stops = Array(Int64).from_json(t["travel_stops"])
      t_travel_stops = parsed_travel_stops

      t_travel_stops = get_travel_stops(parsed_travel_stops, expand: expand, optimize: optimize)

      {"id" => t["id"], "travel_stops" => t_travel_stops}
    end

    return travel_plans_response
  end

  def get_travel_plan_by_id(id, expand, optimize)
    travel_plan = TravelPlan.find(id)

    parsed_response = NamedTuple(id: Int32, travel_stops: String).from_json(travel_plan.to_json)
    travel_plan_response = {
      "id"           => parsed_response["id"],
      "travel_stops" => get_travel_stops(Array(Int64).from_json(parsed_response["travel_stops"]), expand: expand, optimize: optimize),
    }

    return travel_plan_response
  end
end
