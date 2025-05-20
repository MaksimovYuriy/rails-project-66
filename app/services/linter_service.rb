# frozen_string_literal: true

require 'open3'

class LinterService
  def initialize(check_id, output_dir: '/tmp')
    check = Repository::Check.find(check_id)

    @clone_url = check.repository.clone_url
    @check = check
    @language = check.repository.language
    @local_repo_path = "#{output_dir}/#{check.repository.full_name}"
  end

  def call
    clone_repo
    run_linter
    CheckMailer.check_finished(@check).deliver_now
  rescue StandardError => e
    @check.fail!
    CheckMailer.check_failed(@check).deliver_now
    Rails.logger.error "Check failed with error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  ensure
    cleanup
  end

  private

  def clone_repo
    @check.to_clone!

    cmd = "git clone #{@clone_url} #{@local_repo_path}"
    _, stderr, status = Open3.capture3(cmd)

    unless status.success?
      raise 'Failed to clone repository!'
    end

    Dir.chdir(@local_repo_path) do
      cmd_commit_id = 'git rev-parse HEAD'
      commit_id, stderr, status = Open3.capture3(cmd_commit_id)
      @check.update!(commit_id: commit_id.chomp)
    end
  end

  def run_linter
    @check.run!

    case @language
    when 'Ruby'
      config = Rails.root.join('.rubocop.yml').to_s
      cmd = "bundle exec rubocop --config #{config} #{@local_repo_path} --format json"
    when 'JavaScript'
      config = Rails.root.join('.eslintrc.js').to_s
      cmd = "npx eslint --no-eslintrc --config '#{config}' '#{@local_repo_path}' --format=json"
    else
      raise 'Unknown language'
    end

    stdout, stderr, status = Open3.capture3(cmd)

    parsed_data = LinterParser.parse(@language, stdout, @check.commit_id)

    case status.exitstatus
    when 0
      @check.update!(output: stdout, files: parsed_data[:files], summary: parsed_data[:summary], passed: true)
      @check.finish!
    when 1
      @check.update!(output: stdout, files: parsed_data[:files], summary: parsed_data[:summary], passed: false)
      @check.finish!
    when 2
      @check.update!(output: stderr)
      raise 'Startup error!'
    end
  end

  def cleanup
    FileUtils.rm_rf(@local_repo_path)
  end
end
