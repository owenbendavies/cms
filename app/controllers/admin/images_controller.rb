module Admin
  class ImagesController < ApplicationController
    def index
      authorize Image
      @images = policy_scope(Image).ordered
    end
  end
end
