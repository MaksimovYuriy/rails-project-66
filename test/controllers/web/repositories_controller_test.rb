# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @github_repos_url = 'https://api.github.com/user/repos'

      @user = users(:user)
      @repo = repositories(:one)

      @attrs = {
        github_id: 2
      }

      Rails.cache.clear

      fixture_body = load_fixture('files/response.json')
      stub_request(:get, "#{@github_repos_url}?per_page=100")
        .with(
          headers: {
            'Accept' => 'application/vnd.github.v3+json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization' => "token #{@user.token}",
            'Content-Type' => 'application/json',
            'User-Agent' => 'Octokit Ruby Gem 10.0.0'
          }
        )
        .to_return(
          status: 200,
          body: fixture_body,
          headers: { 'Content-Type' => 'application/json' }
        )
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
      repository = ::Repository.find_by(github_id: 2)

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
