class Location < Jennifer::Model::Base
  mapping(
    id: Primary64,
    name: String,
    type: String,
    dimension: String,
  )
end
