# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(64)       not null
#  encrypted_password     :string(64)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  sysadmin               :boolean          default(FALSE), not null
#  name                   :string(64)       not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invited_by_id          :integer
#  google_uid             :string
#  uid                    :string           not null
#
# Indexes
#
#  fk__users_invited_by_id              (invited_by_id)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid                   (uid) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_users_invited_by_id  (invited_by_id => users.id) ON DELETE => no_action ON UPDATE => no_action
#

class User < ApplicationRecord
  include DefaultUid
  include Gravtastic

  devise :confirmable,
         :database_authenticatable,
         :invitable,
         :lockable,
         :omniauthable,
         :recoverable,
         :rememberable,
         :timeoutable,
         :trackable,
         :validatable,
         :zxcvbnable

  gravtastic default: 'mm', size: 40

  has_many :sites, through: :site_settings, inverse_of: false

  schema_validations

  scope(:ordered, -> { order(:email) })

  strip_attributes collapse_spaces: true, replace_newlines: true

  validates :email, email_format: true
  validates :name, length: { minimum: 3 }

  def self.find_for_google(uid, email)
    user = User.find_by(google_uid: uid) || User.find_by(email: email)

    user.update!(google_uid: uid) if user && !user.google_uid

    user
  end

  def self.invite_or_add_to_site!(params, site, inviter)
    user = User.find_by(email: params[:email])

    if user&.site_ids&.exclude?(site.id)
      user.site_settings.create!(site: site)
      NotificationsMailer.user_added_to_site(user, site, inviter).deliver_later
      user
    else
      invite_and_add_to_site!(params, site, inviter)
    end
  end

  def self.invite_and_add_to_site!(params, site, inviter)
    user = invite!(params, inviter) do |invitable|
      invitable.skip_invitation = true
    end

    if user.errors.empty?
      user.site_settings.create!(site: site)
      user.deliver_invitation(params)
    end

    user
  end

  def admin_for_site?(site)
    site_settings.find_by(site: site, admin: true).present?
  end

  def site_ids
    site_settings.pluck(:site_id)
  end

  protected

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
