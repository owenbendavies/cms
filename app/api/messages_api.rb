class MessagesAPI < Grape::API
  namespace :messages do
    ENTITY = Entities::Message

    desc 'Messages', success: ENTITY, is_array: true
    paginate
    get do
      authorize Message, :index?
      messages = paginate policy_scope(Message).ordered
      present messages, with: ENTITY
    end

    desc 'Messages', success: ENTITY
    route_param :uid, type: String do
      get do
        message = Message.find_by!(uid: params[:uid])
        authorize message, :show?
        present message, with: ENTITY
      end
    end
  end
end
