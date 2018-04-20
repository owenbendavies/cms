# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  name       :string(64)       not null
#  email      :string(64)       not null
#  phone      :string(32)
#  message    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uid        :string           not null
#
# Indexes
#
#  index_messages_on_created_at  (created_at)
#  index_messages_on_site_id     (site_id)
#  index_messages_on_uid         (uid) UNIQUE
#
# Foreign Keys
#
#  fk_messages_site_id  (site_id => sites.id)
#

class Message < ApplicationRecord
  class Entity < Grape::Entity
    expose :uid, documentation: { type: String }
    expose :name, documentation: { type: String }
    expose :email, documentation: { type: String }
    expose :phone, documentation: { type: String }
    expose :message, documentation: { type: String }
    expose :created_at, documentation: { type: DateTime }
    expose :updated_at, documentation: { type: DateTime }
  end

  include DefaultUid

  attr_accessor :do_not_fill_in

  # relations
  belongs_to :site

  # scopes
  scope(:ordered, -> { order(created_at: :desc) })

  # before validations
  strip_attributes except: :message, collapse_spaces: true, replace_newlines: true

  # validations
  validates(
    :site,
    presence: true
  )

  validates(
    :name,
    length: { minimum: 3, maximum: 64 },
    presence: true
  )

  validates(
    :email,
    email_format: true,
    length: { maximum: 64 },
    presence: true
  )

  validates(
    :phone,
    length: { maximum: 32 },
    phone: { allow_blank: true }
  )

  validates(
    :message,
    length: { maximum: 2048 },
    presence: true
  )

  validates(
    :do_not_fill_in,
    length: { maximum: 0 }
  )
end
