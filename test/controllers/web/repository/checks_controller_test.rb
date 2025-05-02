# frozen_string_literal: true

require 'test_helper'

module Web
  module Repository
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      setup do
        Rails.cache.clear

        @user = users(:user)
        @repository = repositories(:one)
      end

      test 'should create check' do
        sign_in @user
        post repository_checks_path(@repository), params: {}

        assert_equal 2, @repository.checks.count
      end
    end
  end
end
