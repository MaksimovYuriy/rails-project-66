# frozen_string_literal: true

module LinterParser
  module LinterHelpers
    private

    def normalize_path_to_github(filepath, commit_id)
      filepath_split = filepath.split('/')[2..]
      format_parts = []
      format_parts << 'https://github.com'
      format_parts << filepath_split[0..1]
      format_parts << 'blob'
      format_parts << commit_id.to_s
      format_parts << filepath_split[2..]
      format_parts.join('/')
    end
  end
end
