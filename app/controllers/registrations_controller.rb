class RegistrationsController < ApplicationController
  def edit
  end

  def update
    if user.update_attributes(user_params)
      flash.notice = t('flash.updated', name: User.model_name.human)
      redirect_to page_path('home')
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation
    )
  end
end
