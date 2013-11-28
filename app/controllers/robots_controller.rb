class RobotsController < ApplicationController
  skip_before_filter :check_format_is_nil
  before_filter :check_format

  def show
  end

  private

  def check_format
    page_not_found unless params[:format] == 'txt'
  end
end
