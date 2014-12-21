# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  email           :string(64)       not null
#  password_digest :string(64)       not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Account < ActiveRecord::Base
  include Gravtastic

  gravtastic secure: false, default: 'mm', size: 24

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
    account = find_by_email(email.squish.downcase)

    return unless account
    return unless account.authenticate(password.squish)
    return unless account.sites.map(&:host).include? host
    account
  end
end
