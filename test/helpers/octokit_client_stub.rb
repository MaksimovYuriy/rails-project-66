class OctokitClientStub
    def initialize(access_token)
        @access_token = access_token
    end

    def repos
        fixture_path = File.expand_path('../../fixtures/files/response.json', __FILE__)
        repositories = JSON.parse(File.read(fixture_path))
        repositories.map { |repo| Repository.new(repo) }
    end
end