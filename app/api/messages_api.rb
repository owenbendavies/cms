class MessagesAPI < Grape::API
  namespace :messages do
    ENTITY = Entities::Message

    desc 'Messages', success: ENTITY

    params do
      requires :uid, type: String
    end

    route_param :uid do
      get do
        message = Message.find_by!(uid: params[:uid])
        authorize message, :show?
        present message, with: ENTITY
      end
    end
  end
end
