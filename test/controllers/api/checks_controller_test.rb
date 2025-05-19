module Api
    class ChecksControllerTest < ActionDispatch::IntegrationTest

        setup do
            @repo = repositories(:one)
        end

        test 'should create check' do
            payload = {
                repository: {
                    id: @repo[:id]
                }
            }

            assert_difference '@repo.checks.count', 1 do
                perform_enqueued_jobs do
                    post api_checks_path,
                        params: payload.to_json,
                        headers: {
                            'Content-Type' => 'application/json',
                            'X-GitHub-Event' => 'push'
                        }
                end
            end
        end
    end
end