# frozen_string_literal: true

module Web
  class ApplicationController < ApplicationController
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :not_enough_rights

    helper_method :current_user
    helper_method :authenticate_user!

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def authenticate_user!
      return if session[:user_id].present?

      redirect_to root_path, notice: I18n.t('notice.auth.not_authorized')
    end

    private

    def not_enough_rights
      redirect_to root_path, alert: I18n.t('notice.auth.no_rights')
    end
  end
end
