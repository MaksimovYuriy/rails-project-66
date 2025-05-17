# frozen_string_literal: true

module Web
  module Repository
    class ChecksController < Web::ApplicationController
      before_action :authenticate_user!
      before_action :set_repository

      def show
        @check = ::Repository::Check.find(params[:id])
        authorize @check, policy_class: Web::Repository::CheckPolicy
      end

      def create
        authorize @repository, policy_class: Web::Repository::CheckPolicy
        check = @repository.checks.build
        check.save
        RepositoryCheckJob.perform_later(@repository, check)
        redirect_to repository_path(@repository), notice: I18n.t('repository.check.start')
      end

      private

      def set_repository
        @repository = ::Repository.find(params[:repository_id])
      end
    end
  end
end
