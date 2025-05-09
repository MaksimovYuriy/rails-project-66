# frozen_string_literal: true

class OctokitClientStub
  def initialize(access_token)
    @access_token = access_token
  end

  def repos
    fixture_path = File.expand_path('../test/fixtures/files/response.json', __dir__)
    repositories = JSON.parse(File.read(fixture_path))
    repositories.map { |repo| Repository.new(repo) }
  end
end
