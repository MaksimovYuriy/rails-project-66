class CheckMailer < ApplicationMailer
    default from: 'no-reply@quality.io'

    def check_failed(check)
        @check = check
        @user_email = user_email_from_check(check)
        return unless @user_email.present?

        mail(to: @user_email, subject: 'Check Failed')
    end

    private

    def user_email_from_check(check)
        check.repository&.user&.email
    end

end
