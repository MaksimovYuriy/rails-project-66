require 'open3'

class LinterService

    def initialize(clone_url, check, output_dir: '/tmp')
        @clone_url = clone_url
        @check = repository_check
        @output_dir = output_dir
        generate_temp_dir
    end

    def call
        begin
            clone_repo
            run_linter
            @check.complete!
        rescue StandardError => e
            @check.fail!
        end
    end

    private

    def clone_repo
        @check.clone!
        clone_path = "#{@output_dir}/#{@temp_dir}"

        cmd = "git clone #{clone_url} #{clone_path}"
        _, stderr, status = Open3.capture3(cmd)

        if !status.success
            raise "Failed to clone repository!"
        end
    end

    def run_linter
        @check.run!
        repo_path = "#{@output_dir}/#{@temp_dir}"
        rubocop_config = Rails.root.join('.rubocop.yml').to_s

        cmd = "bundle exec rubocop --config #{rubocop_config} #{repo_path}"
        stdout, stderr, status = Open3.capture3(cmd)

        debugger

        if !status.success
            raise "Failed to clone repository!"
        end
    end

    def generate_temp_dir
        @temp_dir = SecureRandom.hex(8)
    end

end