class UsersController < ApplicationController
  before_filter :login_required

  def index
    @account_emails = Account.find_emails_by_site(@site)
  end
end
