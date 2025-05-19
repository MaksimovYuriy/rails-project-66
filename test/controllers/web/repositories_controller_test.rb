# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:user)
      @repo = repositories(:one)

      @attrs = {
        github_id: 2,
        name: 'test_name_2',
        full_name: 'test_full_name_2',
        language: 'Ruby',
        clone_url: 'some_clone_url_2',
        ssh_url: 'some_ssh_url_2'
      }

      load_fixture('files/response.json')
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

      @attrs.each do |key, value|
        assert_equal value, repository.send(key)
      end
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
