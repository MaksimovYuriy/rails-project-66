# frozen_string_literal: true

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest

    setup do
      @user = users(:user)
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
          email: 'test@gmail.com'
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

    test 'should logout' do
      sign_in @user

      delete auth_logout_path

      assert_nil current_user
    end

    test 'login failure' do
      sign_in @user

      get auth_failure_path

      assert_response :redirect
      assert_nil current_user
    end
  end
end
