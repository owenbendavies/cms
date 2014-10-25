class ImagesController < ApplicationController
  def index
    @images = Image.find_all_by_site(@site)
  end
end
