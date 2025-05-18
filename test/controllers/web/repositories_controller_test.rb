# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:user)
      @repo = repositories(:one)

      @attrs = {
        github_id: 535_535
      }

      fixture_body = load_fixture('files/response.json')
    end

    test 'index page not authorized' do
      get repositories_url

      assert_response :redirect
    end

    test 'index page authorized' do
      sign_in(@user)

      get repositories_url

      assert_response :success
    end

    test 'new page unauthorized' do
      get new_repository_path

      assert_response :redirect
    end

    test 'new page authorized' do
      sign_in @user

      get new_repository_path

      assert_response :success
    end

    test 'should create' do
      sign_in @user

      post repositories_path, params: { repository: @attrs }
      repository = ::Repository.find_by(github_id: @attrs[:github_id])

      assert_response :redirect
      assert { repository }
    end

    test 'show page unauthorized' do
      get repository_path(@repo)

      assert_response :redirect
    end

    test 'show page authorized' do
      sign_in @user

      get repository_path(@repo)

      assert_response :success
    end
  end
end
