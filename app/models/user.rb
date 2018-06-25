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

  # relations
  has_many :site_settings, dependent: :destroy
  has_many :sites, through: :site_settings

  # scopes
  scope(:ordered, -> { order(:email) })

  # before validations
  strip_attributes collapse_spaces: true, replace_newlines: true

  # validations
  validates(
    :email,
    email_format: true,
    length: { maximum: 64 },
    presence: true,
    uniqueness: true
  )

  validates(
    :name,
    length: { minimum: 3, maximum: 64 },
    presence: true
  )

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
