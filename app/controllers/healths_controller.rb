class HealthsController < ApplicationController
  skip_before_filter :find_site

  def show
    render text: 'ok'
  end
end
