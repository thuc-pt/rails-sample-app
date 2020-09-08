class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :language

  def logged_in?
    return if current_user.present?
    flash[:danger] = t ".check_login"
    redirect_to signin_path
  end

  private

  def language
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash[:notice] = params[:locale] << I18n.t(".notice_sp")
      end
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
