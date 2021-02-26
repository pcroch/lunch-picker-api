# frozen_string_literal: true

class LunchPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def update?
    record.user == user
  end

  def create?
    # Any logged in user can create a restaruent
    !user.nil?
  end

  def destroy?
    # record.user == user
    update?
  end
end
