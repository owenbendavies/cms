# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  subject    :string(255)      not null
#  name       :string(64)       not null
#  email      :string(64)       not null
#  phone      :string(32)
#  delivered  :boolean
#  message    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DBMessage < ActiveRecord::Base
  self.table_name = 'messages'

  belongs_to :site, class_name: 'DBSite'
end
