# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      auth = request.env['omniauth.auth']

      user = User.find_or_initialize_by(email: auth.info.email)
      user.nickname = auth.info.nickname
      user.token = auth.credentials.token
      user.save!

      session[:user_id] = user.id
      redirect_to root_path, notice: I18n.t('notice.auth.success')
    end

    def failure
      session[:user_id] = nil
      redirect_to root_path, notice: I18n.t('notice.auth.error')
    end

    def logout
      session[:user_id] = nil
      redirect_to root_path, notice: I18n.t('notice.auth.logout')
    end
  end
end
