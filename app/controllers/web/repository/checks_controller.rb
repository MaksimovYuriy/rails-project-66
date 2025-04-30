module Web
    module Repository
        class ChecksController < Web::ApplicationController
            before_action :authenticate_user!
            before_action :set_repository

            def create
                check = @repository.checks.build()
                linter = ApplicationContainer[:linter].new(@repository.clone_url, check)
                linter.call
            end

            def show

            end

            private

            def set_repository
                @repository = ::Repository.find(params[:repository_id])
            end

        end
    end
end