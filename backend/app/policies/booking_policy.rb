class BookingPolicy < ApplicationPolicy
  def show?
    record.user == user || user.admin?
  end

  def destroy?
    record.user == user && record.confirmed?
  end
end
