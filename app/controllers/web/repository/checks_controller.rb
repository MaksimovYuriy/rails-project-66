module Web
    module Repository
        class ChecksController < Web::ApplicationController
            before_action :authenticate_user!
            before_action :set_repository

            def create
                RepositoryCheckJob.perform_later(@repository)
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