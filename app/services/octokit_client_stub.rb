# frozen_string_literal: true

class OctokitClientStub
  def initialize(access_token)
    @access_token = access_token
  end

  def repos
    fixture_path = Rails.root.join('test/fixtures/files/response.json')
    repositories = JSON.parse(File.read(fixture_path))
    repositories.map { |repo| Repository.new(repo) }
  end

  def hooks(_full_name)
    []
  end

  def create_hook(full_name, web, url, event); end
end
