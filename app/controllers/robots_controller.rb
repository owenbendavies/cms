class RobotsController < ApplicationController
  def show
    if @site.allow_search_engines
      render :show
    else
      render 'robots/disallowed.txt'
    end
  end
end
