# frozen_string_literal: true

class LinterServiceStub
  def initialize(clone_url, check, language, repo_full_name, output_dir: '/tmp')
    @clone_url = clone_url
    @check = check
    @language = language
    @output_dir = output_dir
    @temp_dir = repo_full_name
  end

  def call
    clone_repo
    run_linter
    cleanup
    @check.finish!
  rescue StandardError
    @check.fail!
  end

  private

  def clone_repo
    @check.to_clone!
    commit_id = 'test commit id'
    @check.update!(commit_id: commit_id)
  end

  def run_linter
    @check.run!
    output = 'some output of linter'
    @check.update!(output: output)
  end

  def cleanup; end
end
