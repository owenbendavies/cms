class ImagesController < ApplicationController
  before_filter :login_required

  def index
    @images = Image.find_all_by_site(@site)
  end
end
