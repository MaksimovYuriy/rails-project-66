require "test_helper"

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest

    test 'index page not authorized' do
      get repositories_url
      assert_response :redirect
    end

    test 'index page authorized' do
      sign_in(users(:user))
      get repositories_url
      assert_response :success
    end

    

  end
end