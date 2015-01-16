# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(64)       not null
#  password_digest :string(64)       not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  include Gravtastic

  gravtastic default: 'mm', size: 40

  has_secure_password

  has_and_belongs_to_many :sites, -> { order :name }

  has_paper_trail

  strip_attributes only: :email, collapse_spaces: true

  validates :email,
            presence: true,
            length: { maximum: 64 },
            email_format: true,
            uniqueness: true

  validates :password,
            length: { minimum: 8, maximum: 64, allow_blank: true },
            password_strength: true

  def self.find_and_authenticate(email, password, host)
    user = find_by_email(email.squish.downcase)

    return unless user
    return unless user.authenticate(password.squish)
    return unless user.sites.map(&:host).include? host
    user
  end
end
