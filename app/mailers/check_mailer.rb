# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  default from: 'no-reply@quality.io'

  def check_failed(check)
    @check = check
    @user_email = user_email_from_check(check)
    return if @user_email.blank?

    mail(to: @user_email, subject: I18n.t('mail.subject'))
  end

  private

  def user_email_from_check(check)
    check.repository&.user&.email
  end
end
