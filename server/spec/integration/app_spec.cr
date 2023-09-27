require "../spec_helper"
require "../mocks/travel_plans_mock"

HEADERS = HTTP::Headers{"Content-Type" => "application/json"}

describe "Multiverse Travels Booker API" do
  Spec.before_each do
    # Inicia uma transação de banco de dados antes de cada teste
    Jennifer::Adapter.default_adapter.begin_transaction
  end

  Spec.after_each do
    # Desfaz a transação de banco de dados após cada teste
    Jennifer::Adapter.default_adapter.rollback_transaction
  end

  describe "POST /travel_plans" do
    it "returns a 201 status code and creates a travel plan" do
      post "/travel_plans", HEADERS, {travel_stops: [1, 2, 3, 4]}.to_json
      id = JSON.parse(response.body)["id"].as_i
      expected_response = {id: id, travel_stops: [1, 2, 3, 4]}.to_json

      response.status_code.should eq 201
      response.body.should eq expected_response
    end
  end

  describe "GET /travel_plans" do
    it "returns an empty array when there are no travel plans" do
      get "/travel_plans"

      response.status_code.should eq 200
      response.body.should eq "[]"
    end

    it "returns a 200 status code and an array of travel plans" do
      post "/travel_plans", HEADERS, {travel_stops: [1, 2, 3, 4]}.to_json
      id1 = JSON.parse(response.body)["id"].as_i
      post "/travel_plans", HEADERS, {travel_stops: [2, 7]}.to_json
      id2 = JSON.parse(response.body)["id"].as_i
      post "/travel_plans", HEADERS, {travel_stops: [7]}.to_json
      id3 = JSON.parse(response.body)["id"].as_i

      get "/travel_plans"

      expected_response = [{id: id1, travel_stops: [1, 2, 3, 4]},
                           {id: id2, travel_stops: [2, 7]},
                           {id: id3, travel_stops: [7]}].to_json

      response.status_code.should eq 200
      response.body.should eq expected_response
    end

    it "returns travel_plans with their travel_stops expanded when the expand parameter is provided" do
      post "/travel_plans", HEADERS, {travel_stops: [1, 2]}.to_json
      id1 = JSON.parse(response.body)["id"].as_i
      post "/travel_plans", HEADERS, {travel_stops: [3, 7]}.to_json
      id2 = JSON.parse(response.body)["id"].as_i

      get "/travel_plans?expand=true"

      expected_response = get_travel_plans_expanded_from_db(id1, id2).to_json

      response.status_code.should eq 200
      response.body.should eq expected_response
    end

    it "returns travel_plans with their travel_stops expanded and optimized when the parameters are true" do
      post "/travel_plans", HEADERS, {travel_stops: [2, 3, 7]}.to_json
      id1 = JSON.parse(response.body)["id"].as_i

      get "/travel_plans?expand=true&optimize=true"

      expected_response = get_travel_plans_expanded_and_optimized_from_db(id1).to_json

      response.status_code.should eq 200
      response.body.should eq expected_response
    end
  end

  describe "GET /travel_plans/:id" do
    it "returns a 404 error message when the travel plan does not exist" do
      get "/travel_plans/1"

      error_message = JSON.parse(response.body)

      response.status_code.should eq 404
      error_message["message"].should eq "travel_plan with id 1 not found"
    end

    it "returns a 200 status code and a travel plan" do
      post "/travel_plans", HEADERS, {travel_stops: [6, 7]}.to_json
      id = JSON.parse(response.body)["id"].as_i

      get "/travel_plans/#{id}"

      expected_response = {id: id, travel_stops: [6, 7]}.to_json

      response.status_code.should eq 200
      response.body.should eq expected_response
    end

    it "returns a 200 status code and a travel plan with their travel stops expanded and optimized when the parameters are provided" do
      post "/travel_plans", HEADERS, {travel_stops: [2, 3, 7]}.to_json
      id = JSON.parse(response.body)["id"].as_i

      get "/travel_plans/#{id}?expand=true&optimize=true"

      expected_response = get_travel_plans_expanded_and_optimized_from_db(id)[0].to_json

      response.status_code.should eq 200
      response.body.should eq expected_response
    end
  end

  describe "PUT /travel_plans/:id" do
    it "returns a 404 error message when the travel plan does not exist" do
      put "/travel_plans/1", HEADERS, {travel_stops: [1, 2, 3, 4]}.to_json

      error_message = JSON.parse(response.body)

      response.status_code.should eq 404
      error_message["message"].should eq "travel_plan with id 1 not found"
    end

    it "returns a 200 status code and updates a travel plan" do
      post "/travel_plans", HEADERS, {travel_stops: [1, 2, 3, 4]}.to_json
      id = JSON.parse(response.body)["id"].as_i

      put "/travel_plans/#{id}", HEADERS, {travel_stops: [9, 4]}.to_json

      expected_response = {id: id, travel_stops: [9, 4]}.to_json

      response.status_code.should eq 200
      response.body.should eq expected_response
    end
  end

  describe "DELETE /travel_plans/:id" do
    it "returns a 404 error message when the travel plan does not exist" do
      delete "/travel_plans/1"

      error_message = JSON.parse(response.body)

      response.status_code.should eq 404
      error_message["message"].should eq "travel_plan with id 1 not found"
    end

    it "returns a 200 status code and deletes a travel plan" do
      post "/travel_plans", HEADERS, {travel_stops: [1, 2, 3, 4]}.to_json
      id = JSON.parse(response.body)["id"].as_i

      delete "/travel_plans/#{id}"

      response.status_code.should eq 204
      response.body.should eq ""
    end
  end
end
