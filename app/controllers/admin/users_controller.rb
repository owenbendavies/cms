module Admin
  class UsersController < ApplicationController
    def index
      authorize User
      @users = policy_scope(User).ordered
    end
  end
end
