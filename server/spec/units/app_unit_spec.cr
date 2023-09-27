require "../spec_helper"
require "../mocks/travel_plans_mock"
require "../../src/utils/travel_stops"

describe "Multiverse Travels Booker API" do
  describe "get_travel_stops func" do
    it "return a list of travel stops when params are not provided" do
      travel_stops = get_travel_stops([1, 2])

      travel_stops.as(Array(Int32)).size.should eq 2
      travel_stops.should eq [1, 2]
    end

    it "return a list of travels expanded when expand param is true" do
      travel_stops = get_travel_stops([1, 2], expand: true)

      travel_stops.as(Array(NamedTuple(id: Int32, name: String, dimension: String, type: String))).size.should eq 2
      travel_stops.should eq [{id: 1, name: "Earth (C-137)", dimension: "Dimension C-137", type: "Planet"},
                              {id: 2, name: "Abadango", dimension: "unknown", type: "Cluster"}]
    end

    it "return a list of travels optimized when optimize param is true" do
      travel_stops = get_travel_stops([2, 3, 7], expand: false, optimize: true)

      travel_stops.should_not eq [2, 3, 7]
      travel_stops.should eq [2, 7, 3]
    end

    it "return a list of travels optimized and expanded when params are true" do
      travel_stops = get_travel_stops([2, 3, 7], expand: true, optimize: true)

      travel_stops.should eq get_travel_plans_expanded_and_optimized_from_db(1)[0]["travel_stops"]
    end
  end
end
