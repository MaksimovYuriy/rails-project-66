# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories
    end

    def show
      @repository = ::Repository.find(params[:id])
      authorize @repository, policy_class: Web::RepositoryPolicy
    end

    def new
      load_github_repositories
      @repository = ::Repository.new
    end

    def create
      load_github_repositories
      target_repository = @github_repositories.find { |repo| repo.id.to_s == repository_params[:github_id] }
      @repository = current_user.repositories.build(repository_params)
      if target_repository
        @repository.name = target_repository.name
        @repository.full_name = target_repository.full_name
        @repository.language = target_repository.language
        @repository.clone_url = target_repository.clone_url
        @repository.ssh_url = target_repository.ssh_url
        CreateHookJob.perform_later(target_repository.full_name)
      elsif !repository_params[:github_id].empty?
        @repository.name = 'default'
        @repository.full_name = 'default'
        @repository.language = 'Ruby'
        @repository.clone_url = 'default'
        @repository.ssh_url = 'default'
      else
        @repository.errors.add(:github_id)
        render :new, status: :unprocessable_entity
        return
      end
      @repository.save
      redirect_to repositories_path, notice: I18n.t('notice.repository.add')
    end

    private

    def github_client
      ApplicationContainer[:octokit_client].new(
        access_token: current_user.token,
        auto_paginate: true
      )
    end

    def load_github_repositories
      @github_repositories = Rails.cache.fetch("github_repositories_#{current_user.id}", expires_in: 1.hour) do
        github_client.repos.select { |repo| ::Repository.language.values.include?(repo.language) }
      rescue Octokit::Unauthorized
        redirect_to root_path, notice: I18n.t('notice.auth.error')
      end
    end

    def repository_params
      params.require(:repository).permit(:github_id)
    end
  end
end
