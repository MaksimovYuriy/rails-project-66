require "test_helper"

module Web
  class WelcomeControllerTest < ActionDispatch::IntegrationTest
    
    test 'root page' do
      get root_url
      assert_response :success
    end

  end
end
