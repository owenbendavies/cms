class Ability
  include CanCan::Ability

  # https://github.com/CanCanCommunity/cancancan/wiki/Action-Aliases
  # alias_action :index, :show, :to => :read
  # alias_action :new, :to => :create
  # alias_action :edit, :to => :update

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
    can [:read], Image, site_id: user.site_ids
    can [:read], Message, site_id: user.site_ids
    can [:crud], Page, site_id: user.site_ids
    can [:read, :update, :css], Site, id: user.site_ids
    can [:index], Site
  end

  def all_abilities
    can [:read, :contact_form], Page, private: false
  end
end
