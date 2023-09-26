require "../spec_helper"

HEADERS = HTTP::Headers{"Content-Type" => "application/json"}

describe "Travel Plans API" do
  Spec.before_each do
    # Inicia uma transação de banco de dados antes de cada teste
    Jennifer::Adapter.default_adapter.begin_transaction
  end

  Spec.after_each do
    # Desfaz a transação de banco de dados após cada teste
    Jennifer::Adapter.default_adapter.rollback_transaction
  end

  describe "GET /travel_plans" do
    it "returns an empty array when there are no travel plans" do
      get "/travel_plans"

      response.body.should eq "[]"
      response.status_code.should eq 200
    end
  end

  describe "GET /travel_plans/:id" do
    it "returns a 404 error message when the travel plan does not exist" do
      get "/travel_plans/1"

      error_message = JSON.parse(response.body)

      error_message["message"].should eq "travel_plan with id 1 not found"
      response.status_code.should eq 404
    end
  end

  describe "POST /travel_plans" do
    it "returns a 201 status code and creates a travel plan" do
      post "/travel_plans", HEADERS, {travel_stops: [1, 2, 3, 4]}.to_json
      id = JSON.parse(response.body)["id"].as_i
      expected_response = {id: id, travel_stops: [1, 2, 3, 4]}.to_json

      response.body.should eq expected_response
      response.status_code.should eq 201
    end
  end

  describe "PUT /travel_plans/:id" do
    it "returns a 404 error message when the travel plan does not exist" do
      put "/travel_plans/1", HEADERS, {travel_stops: [1, 2, 3, 4]}.to_json

      error_message = JSON.parse(response.body)

      error_message["message"].should eq "travel_plan with id 1 not found"
      response.status_code.should eq 404
    end

    it "returns a 200 status code and updates a travel plan" do
      post "/travel_plans", HEADERS, {travel_stops: [1, 2, 3, 4]}.to_json
      id = JSON.parse(response.body)["id"].as_i

      put "/travel_plans/#{id}", HEADERS, {travel_stops: [9, 4]}.to_json
      response.status_code.should eq 200
    end
  end
end
