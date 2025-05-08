module Web
    class AuthControllerTest < ActionDispatch::IntegrationTest

        setup do

        end

        test 'guthub auth page' do
            post auth_request_path('github')

            assert_response :redirect
        end

        test 'create new user' do
            auth_hash = {
                provider: 'github',
                uid: '12345',
                info: {
                    nickname: 'TestName',
                    email: 'test@gmail.com',
                },
                credentials: {
                    token: 'test_token'
                }
            }

            OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

            get callback_auth_path('github')
            assert_response :redirect

            user = User.find_by(email: auth_hash[:info][:email])

            assert user
            assert signed_in?
        end

    end
end