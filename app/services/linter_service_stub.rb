# frozen_string_literal: true

class LinterServiceStub
  def initialize(check_id, output_dir: '/tmp')
    check = Repository::Check.find(check_id)

    @clone_url = check.repository.clone_url
    @check = check
    @language = check.repository.language
    @output_dir = output_dir
    @temp_dir = check.repository.full_name
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
    @check.update!(output: output, passed: true)
  end

  def cleanup; end
end
