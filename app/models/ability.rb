class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    if user && user.admin?
      can :manage, :all
    else
      user_abilities(user) if user

      all_abilities
    end
  end

  def user_abilities(user)
    can [:read], Image, site_id: user.site_settings.pluck(:site_id)
    can [:read], Message, site_id: user.site_settings.pluck(:site_id)
    can :crud, Page, site_id: user.site_settings.pluck(:site_id)
    can [:read, :update, :css], Site, id: user.site_settings.pluck(:site_id)
  end

  def all_abilities
    can [:read, :contact_form], Page, private: false
  end
end
