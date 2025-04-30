require 'open3'

class LinterService

    def initialize(clone_url, check, output_dir: '/tmp')
        @clone_url = clone_url
        @check = check
        @output_dir = output_dir
        @temp_dir = generate_temp_dir
    end

    def call
        begin
            clone_repo
            run_linter
            cleanup
            @check.complete!
        rescue StandardError => e
            @check.fail!
        end
    end

    private

    def clone_repo
        @check.clone!
        clone_path = "#{@output_dir}/#{@temp_dir}"

        cmd = "git clone #{@clone_url} #{clone_path}"
        _, stderr, status = Open3.capture3(cmd)

        if !status.success?
            raise "Failed to clone repository!"
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
        rubocop_config = Rails.root.join('.rubocop.yml').to_s

        begin
            cmd = "bundle exec rubocop --config #{rubocop_config} #{repo_path}"
            stdout, stderr, status = Open3.capture3(cmd)
        rescue StandardError => e
            @check.fail!
        end
        
    end

    private

    def generate_temp_dir
        SecureRandom.hex(8)
    end

    def cleanup
        temp_path = "#{@output_dir}/#{@temp_dir}"
        FileUtils.rm_rf(temp_path) if Dir.exist?(temp_path)
    end

end