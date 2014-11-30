class ImagesController < ApplicationController
  def index
    @images = @site.images
  end
end
