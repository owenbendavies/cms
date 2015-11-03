class Ability
  include CanCan::Ability

  # https://github.com/CanCanCommunity/cancancan/wiki/Action-Aliases
  # alias_action :index, :show, :to => :read
  # alias_action :new, :to => :create
  # alias_action :edit, :to => :update

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    if user
      admin_abilities if user.admin
      user_abilities(user)
    end

    all_abilities
  end

  def admin_abilities
    can [:error_500, :error_delayed, :error_timeout], :system
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
