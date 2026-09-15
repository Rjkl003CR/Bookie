# app/models/user.rb
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Roles: passenger, bus_owner, admin
  enum role: { passenger: 0, bus_owner: 1, admin: 2 }

  has_many :bookings, dependent: :destroy
  has_many :buses, dependent: :destroy, foreign_key: :owner_id

  validates :role, presence: true

  # JWT payload customization (FR-AUTH-02)
  def jwt_payload
    super.merge("role" => role)
  end
end
