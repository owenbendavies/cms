class MessagesAPI < Grape::API
  namespace :messages do
    ENTITY = Entities::Message

    desc 'Messages', success: ENTITY

    params do
      requires :uuid, type: String
    end

    route_param :uuid do
      get do
        message = Message.find_by!(uuid: params[:uuid])
        authorize message, :show?
        present message, with: ENTITY
      end
    end
  end
end
