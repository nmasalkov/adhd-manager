class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :check_if_too_many_registrations

  protected

  def check_if_too_many_registrations
    lately_created_users = User.where(created_at: Date.yesterday..).count
    raise 'too many users!' if lately_created_users > 5
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:login, :password, :password_confirmation])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:login, :password, :password_confirmation, :current_password])
  end
end
