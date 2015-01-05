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
#  delivered  :boolean          default("false"), not null
#  message    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ActiveRecord::Base
  attr_accessor :do_not_fill_in

  belongs_to :site

  has_paper_trail

  strip_attributes except: :message, collapse_spaces: true

  validates *attribute_names, no_html: true
  validates :site_id, presence: true
  validates :subject, presence: true
  validates :name, presence: true, length: { maximum: 64 }
  validates :email, presence: true, length: { maximum: 64 }, email_format: true
  validates :phone, length: { maximum: 32 }
  validates :message, presence: true, length: { maximum: 2048 }
  validates :do_not_fill_in, length: { maximum: 0 }

  validate do
    text = message.to_s.downcase

    [
      'facebook followers',
      'facebook likes',
      'facebook page likes',
      'facebook visitors',
      'first page of google',
      'search engine',
      'superbsocial'
    ].each do |spam_text|
      errors.add(:message, :spam) if text.include? spam_text
    end
  end

  def deliver
    MessageMailer.new_message(self).deliver_now
    self.delivered = true
    self.save!
  end
end
