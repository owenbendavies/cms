class GraphqlController < ApplicationController
  skip_after_action :verify_authorized, only: %i[execute]

  def execute
    render json: GraphqlSchema.execute(params[:query], context: pundit_user, variables: params[:variables])
  end
end
