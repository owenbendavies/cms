# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  subject    :string(64)       not null
#  name       :string(64)       not null
#  email      :string(64)       not null
#  phone      :string(32)
#  message    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  fk__messages_site_id  (site_id)
#
# Foreign Keys
#
#  fk_messages_site_id  (site_id => sites.id)
#

class MessagesController < ApplicationController
  def index
    authorize Message
    @messages = policy_scope(Message).ordered.paginate(page: params[:page])
  end

  def show
    @message = @site.messages.find(params[:id])
    authorize @message
  end
end
