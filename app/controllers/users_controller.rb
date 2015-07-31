class UsersController < ApplicationController
  authorize_resource :site

  def index
  end
end
