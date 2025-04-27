module TestHelpers

    def sign_in(user)
        auth_hash = {
            provider: 'github',
            uid: '12345',
            info: {
                email: user.email,
                nickname: user.nickname,
            },
            credentials: {
                token: user.token
            }
        }

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

        get callback_auth_url('github')
    end

    def signed_in?
        session[:user_id].present? && current_user.present?
    end

    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end

end