def get_travel_plans_expanded_from_db(id1, id2)
  return [
    {
      id:           id1,
      travel_stops: [
        {id: 1, name: "Earth (C-137)", dimension: "Dimension C-137", type: "Planet"},
        {id: 2, name: "Abadango", dimension: "unknown", type: "Cluster"},
      ],
    },
    {
      id:           id2,
      travel_stops: [
        {id: 3, name: "Citadel of Ricks", dimension: "unknown", type: "Space station"},
        {id: 7, name: "Immortality Field Resort", dimension: "unknown", type: "Resort"},
      ],
    },
  ]
end

def get_travel_plans_expanded_and_optimized_from_db(id1)
  return [
    {
      id:           id1,
      travel_stops: [
        {id: 2, name: "Abadango", dimension: "unknown", type: "Cluster"},
        {id: 7, name: "Immortality Field Resort", dimension: "unknown", type: "Resort"},
        {id: 3, name: "Citadel of Ricks", dimension: "unknown", type: "Space station"},
      ],
    },
  ]
end
