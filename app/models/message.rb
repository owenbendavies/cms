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
#  user_agent :text
#  ip_address :string(45)
#
# Indexes
#
#  fk__messages_site_id  (site_id)
#
# Foreign Keys
#
#  fk_messages_site_id  (site_id => sites.id)
#

class Message < ActiveRecord::Base
  attr_accessor :do_not_fill_in

  has_paper_trail

  schema_validations

  strip_attributes except: :message, collapse_spaces: true

  validates :name, length: { minimum: 3 }
  validates :email, email_format: true
  validates :message, length: { maximum: 2048 }
  validates :do_not_fill_in, length: { maximum: 0 }

  def phone=(value)
    super(Phoner::Phone.parse(value, country_code: '44'))
  end
end
