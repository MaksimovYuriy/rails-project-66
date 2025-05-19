# frozen_string_literal: true

require 'test_helper'

module Web
  module Repository
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      setup do
        Rails.cache.clear

        @user = users(:user)
        @repository = repositories(:one)
        @check = repository_checks(:one_repo_check)
      end

      test 'should create check' do
        sign_in @user

        assert_difference '@repository.checks.count', 1 do
          perform_enqueued_jobs do
            post repository_checks_path(@repository), params: {}
          end
        end
      end

      test 'show page unauthorized' do
        get repository_check_path(@check.repository, @check)

        assert_response :redirect
      end

      test 'show page authorized' do
        sign_in @user

        get repository_check_path(@check.repository, @check)

        assert_response :success
      end
    end
  end
end
