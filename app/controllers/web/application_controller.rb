# frozen_string_literal: true

module Web
  class ApplicationController < ApplicationController
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :not_enough_rights

    helper_method :current_user
    helper_method :authenticate_user!
    helper_method :get_filename_from_url
    helper_method :get_url_from_commit_id

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def authenticate_user!
      return if session[:user_id].present?

      redirect_to root_path, notice: I18n.t('notice.auth.not_authorized')
    end

    def get_filename_from_url(url)
      parts = url.to_s.split('/')
      return if parts.size < 2

      if parts[-2] == 'main'
        parts[-1]
      else
        File.join(parts[-2], parts[-1])
      end
    end

    def get_url_from_commit_id(clone_url, commit_id)
      format_clone_url = clone_url.to_s[0..-5] # Удалялем ".git"
      [format_clone_url, 'commit', commit_id.to_s].join('/')
    end

    private

    def not_enough_rights
      redirect_to root_path, alert: I18n.t('notice.auth.no_rights')
    end
  end
end
