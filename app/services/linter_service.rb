# frozen_string_literal: true

require 'open3'

class LinterService
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
  rescue StandardError
    @check.fail!
  end

  private

  def clone_repo
    @check.to_clone!
    clone_path = "#{@output_dir}/#{@temp_dir}"

    cmd = "git clone #{@clone_url} #{clone_path}"
    _, stderr, status = Open3.capture3(cmd)

    unless status.success?
      raise 'Failed to clone repository!'
    end

    Dir.chdir(clone_path) do
      cmd_commit_id = 'git rev-parse HEAD'
      commit_id, stderr, status = Open3.capture3(cmd_commit_id)
      @check.update!(commit_id: commit_id.chomp)
    end
  end

  def run_linter
    @check.run!
    repo_path = "#{@output_dir}/#{@temp_dir}"

    case @language
    when 'Ruby'
      config = Rails.root.join('.rubocop.yml').to_s
      cmd = "bundle exec rubocop --config #{config} #{repo_path} --format json"
    when 'JavaScript'
      config = Rails.root.join('.eslintrc.js').to_s
      cmd = "npx eslint --no-eslintrc --config '#{config}' '#{repo_path}' --format=json"
    else
      raise 'Unknown language'
    end

    stdout, stderr, status = Open3.capture3(cmd)

    case status.exitstatus
    when 0
      @check.update!(output: stdout)
      @check.success!
    when 1
      @check.update!(output: stdout)
      @check.fail!
    when 2
      @check.update!(output: stderr)
      @check.fail!
    end
  end

  def cleanup
    temp_path = "#{@output_dir}/#{@temp_dir}"
    FileUtils.rm_rf(temp_path)
  end
end
