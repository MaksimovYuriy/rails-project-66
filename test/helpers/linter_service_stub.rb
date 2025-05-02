# frozen_string_literal: true

class LinterServiceStub

    def initialize(clone_url, check, language, output_dir: '/tmp')
        @clone_url = clone_url
        @check = check
        @language = language
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
        @check.to_clone!
        commit_id = 'test commit id'
        @check.update!(commit_id: commit_id)
    end

    def run_linter
        @check.run!
        output = 'some output of linter'
        @check.update!(output: output)
    end

    def generate_temp_dir
        SecureRandom.hex(8)
    end

    def cleanup; end

end