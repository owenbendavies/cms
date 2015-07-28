class ImagesController < ApplicationController
  authorize_resource :site
  load_and_authorize_resource through: :site

  def index
  end
end
