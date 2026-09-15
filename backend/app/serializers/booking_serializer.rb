class BookingSerializer
  include JSONAPI::Serializer

  attributes :id, :status, :created_at
  belongs_to :schedule
  has_many :seats
end
