# frozen_string_literal: true

module Web
  class ApplicationController < ApplicationController
    helper_method :current_user
    helper_method :authenticate_user!

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def authenticate_user!
      return if session[:user_id].present?

      redirect_to root_path, notice: 'Not authorized'
    end
  end
end
