class MessagesAPI < Grape::API
  namespace :messages do
    desc 'Messages', success: Message::Entity, is_array: true
    paginate
    get do
      authorize Message, :index?
      present paginate(policy_scope(Message).ordered)
    end

    route_param :uid, type: String do
      before do
        @message = Message.find_by!(uid: params[:uid])
      end

      desc 'Messages', success: Message::Entity
      get do
        authorize @message, :show?
        present @message
      end

      desc 'Messages'
      delete do
        authorize @message, :destroy?
        @message.destroy!
        present
      end
    end
  end
end
