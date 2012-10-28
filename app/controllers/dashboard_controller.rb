class DashboardController < ApplicationController

  before_filter :authenticate_user!

  def index
    @users = []
    @sum_debt = 0
    @sum_credit = 0
    User.without(current_user).each do |user|
      sum       = user.owes(current_user)
      own_debt = current_user.owes(user)

      unless sum == 0 && own_debt == 0
        @users << [user, (sum - own_debt).abs, sum > own_debt ? :green : :red]
        if sum > own_debt
          @sum_credit += (sum - own_debt).abs
        else
          @sum_debt += (sum - own_debt).abs
        end
      end
    end
  end

end
