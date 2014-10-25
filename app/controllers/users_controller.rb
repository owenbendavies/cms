class UsersController < ApplicationController
  def index
    @account_emails = Account.find_emails_by_site(@site)
  end
end
