# Multiverse Travels Booker

Multiverse Travels Booker
This API, built using Crystal with the Kemal framework for HTTP requests and the Jennifer ORM, allows users to create, update, and delete travel plans based on a list of stops. Users can submit a list of stops to the service, which processes the information and generates a travel plan.

To access information about each trip, requests are made to the [Rick and Morty API](https://rickandmortyapi.com/). The application also includes automated tests written using Crystal's standard testing library to ensure its correct functionality.

## Installation

1. Run the command ```docker-compose up -d``` to start the database and server.

2. Use a framework of your choice to make requests to the server. For example: [Postman](https://www.postman.com/), [Insomnia](https://insomnia.rest/), Thunder Client (VSCode plugin), etc.

### Requirements

- Docker
- Tools to make HTTP requests

## Usage

The requests below can be made to the following base URL: `http://localhost:3000`

### Endpoints

#### 1. Creating a new travel plan

- Endpoint: `POST /travel_plans`

##### Request

```json
{
  "travel_stops": [2, 3, 7]
}
```

##### Response

```json
{
  "id": 1,
  "travel_stops": [2, 3, 7],
}
```

#### 2. Listing a travel plan

- Endpoint: `GET /travel_plans/:id`

##### Response

```json
{
  "id": 1,
  "travel_stops": [2, 3, 7],
}
```

#### 3. Listing all travel plans

- Endpoint: `GET /travel_plans`

##### Response

```json
[
  {
    "id": 1,
    "travel_stops": [2, 3, 7],
  },
  {
    "id": 2,
    "travel_stops": [2, 7, 9, 11, 19],
  }
]
```

#### 4. Updating a travel plan

- Endpoint: `PUT /travel_plans/:id`

##### Request

```json
{
  "travel_stops": [4, 6]
}
```

##### Response

```json
{
  "id": 1,
  "travel_stops": [4, 6]
}
```

#### 5. Deleting a travel plan

- Endpoint: `DELETE /travel_plans/:id`

##### Response

Empty success response.

#### 6. Appending a stop to a travel plan

- Endpoint: `PATCH /travel_plans/:id/append`

##### Request

```json
{
  "travel_stop": 5
}
```

##### Response

```json
{
  "id": 1,
  "travel_stops": [2, 3, 7, 5]
}
```

### Query Parameters

#### expand

- Upon receiving this parameter, the API expands the stops for each trip, transforming the travel_stops field from an array of integers representing the IDs of each location into an array of objects in the following format, populated with data from the corresponding location recorded in the [Rick and Morty](https://rickandmortyapi.com/) API under the given ID.

  ```json
  {
    "id": 1,
    "name": "Earth (C-137)",
    "type": "Planet",
    "dimension": "Dimension C-137"
  }
  ```

#### optimize

When enabled, this parameter optimizes the travel_stops array to minimize interdimensional jumps and arrange travel stops from the least popular to the most popular locations. To achieve this:

- The API visits all locations within the same dimension before jumping to another dimension.
- Within the same dimension, locations are sorted by popularity in ascending order. In case of a tie, they are sorted alphabetically by name.
- Popularity is determined by counting the number of episodes in which each resident from that location appears.
- Dimensions are visited based on the average popularity of their locations. In case of a tie in average popularity, dimensions are sorted alphabetically.

The result is returned in the travel_stops field, which remains an array of integers or, when used with the expand parameter, an array of expanded location objects.

- Endpoint: `GET /travel_plans/1`

```json
{
  "id": 1,
  "travel_stops": [2, 3, 7]
}
```

- Endpoint: `GET /travel_plans/1?optimize=true`

```json
{
  "id": 1,
  "travel_stops": [2, 7, 3]
}
```

- Endpoint: `GET /travel_plans/1?expand=true&optimize=true`

```json
{
  "id": 2,
  "travel_stops": [
    {
      "id": 2,
      "name": "Abadango",
      "dimension": "unknown",
      "type": "Cluster"
    },
    {
      "id": 7,
      "name": "Immortality Field Resort",
      "dimension": "unknown",
      "type": "Resort"
    },
    {
      "id": 3,
      "name": "Citadel of Ricks",
      "dimension": "unknown",
      "type": "Space station"
    }
  ]
}
```

## Development

1. Uncomment the lines in the docker-compose.yml file.

2. Run the following command to start the database and the server:

```bash
docker-compose up -d
```

3. Enter the server container with this command:

```bash
docker exec -it app_server sh
```

4. To create the database and run the server, use one of the following commands:

- Using Makefile:

```bash
make run start
```

- Or manually:

```bash
make sam db:setup && crystal src/app.cr
```

## Running Tests

Both integration and unit tests are located in the `spec` directory.

To run all the tests for the application, use the following command:

```bash
make run_tests
# Set the test environment, define the port as 3001, set up the test database, run the tests, and drop the test database.
# APP_ENV=test make sam db:setup && APP_ENV=test PORT=3001 KEMAL_ENV=test crystal spec && APP_ENV=test make sam db:drop
```

For only integration tests, use:

```bash
make run_integration_tests
# Set the test environment, define the port as 3001, set up the test database, run integration tests, and drop the test database.
# APP_ENV=test make sam db:setup && APP_ENV=test PORT=3001 KEMAL_ENV=test crystal spec/integration/app_spec.cr && APP_ENV=test make sam db:drop

```

For only unit tests, use:

```bash
make run_unit_tests
# Set the test environment, define the port as 3001, set up the test database, run unit tests, and drop the test database.
#APP_ENV=test make sam db:setup && APP_ENV=test PORT=3001 KEMAL_ENV=test crystal spec/units/travel_plan_service_spec.cr && PORT=3001 KEMAL_ENV=test crystal spec/units/app_unit_spec.cr && APP_ENV=test make sam db:drop
```

## Contributing

1. Fork it (<https://github.com/your-github-user/server/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [coelhoreinaldo](https://github.com/your-github-user) - creator and maintainer
