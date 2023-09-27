require "../spec_helper"
require "../mocks/travel_plans_mock"
require "../../src/utils/travel_stops"

TRAVEL_PLAN_SERVICE_TEST = TravelPlanService.new

describe "Travel Plan Service" do
  it "create travel plan should create a travel plan and return it" do
    travel_plan = TRAVEL_PLAN_SERVICE_TEST.create_travel_plan([2, 3, 7])
    expected_response = {id: travel_plan["id"], travel_stops: [2, 3, 7]}
    travel_plan.should eq expected_response
  end

  it "get travel plan by id should return a travel plan" do
    travel_plan = TRAVEL_PLAN_SERVICE_TEST.create_travel_plan([2, 3, 7])
    expected_response = {id: travel_plan["id"], travel_stops: [2, 3, 7]}
    travel_plan.should eq expected_response
  end

  it "get all travel plans should return all travel plans" do
    travel_plan = TRAVEL_PLAN_SERVICE_TEST.create_travel_plan([2, 3, 7])
    travel_plan2 = TRAVEL_PLAN_SERVICE_TEST.create_travel_plan([3, 2])
    expected_response = [{"id" => travel_plan["id"], "travel_stops" => [2, 3, 7]},
                         {"id" => travel_plan2["id"], "travel_stops" => [3, 2]}]
    travel_plans = TRAVEL_PLAN_SERVICE_TEST.get_all_travel_plans
    travel_plans.should eq expected_response
  end

  it "update travel plan should update a travel plan and return it" do
    travel_plan = TRAVEL_PLAN_SERVICE_TEST.create_travel_plan([2, 3, 7])
    travel_plan = TRAVEL_PLAN_SERVICE_TEST.update_travel_plan(travel_plan["id"], [3, 2])
    expected_response = {id: travel_plan["id"], travel_stops: [3, 2]}
    travel_plan.should eq expected_response
  end

  it "append travel stop should append a travel stop to a travel plan and return it" do
    travel_plan = TRAVEL_PLAN_SERVICE_TEST.create_travel_plan([2, 3, 7])
    travel_plan = TRAVEL_PLAN_SERVICE_TEST.append_travel_stop(travel_plan["id"], 5)
    expected_response = {id: travel_plan["id"], travel_stops: [2, 3, 7, 5]}
    travel_plan.should eq expected_response
  end
end
