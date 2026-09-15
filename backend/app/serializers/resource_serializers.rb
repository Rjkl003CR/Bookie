class RouteSerializer
  include JSONAPI::Serializer

  attributes :id, :origin, :destination
end

class ScheduleSerializer
  include JSONAPI::Serializer

  attributes :id, :departure_time, :arrival_time, :fare
  belongs_to :route
  belongs_to :bus
end

class BusSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :plate_number, :total_seats
end
