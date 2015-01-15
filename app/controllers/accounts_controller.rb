class AccountsController < ApplicationController
  def edit
  end

  def update
    if user.update_attributes(account_params)
      flash.notice = t('flash.updated', name: Account.model_name.human)
      redirect_to page_path('home')
    else
      render :edit
    end
  end

  private

  def account_params
    params.require(:account).permit(
      :email,
      :password,
      :password_confirmation
    )
  end
end
