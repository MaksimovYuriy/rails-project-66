# frozen_string_literal: true

module LinterParser
  module LinterHelpers
    private

    def normalize_path_to_github(filepath)
      filepath_split = filepath.split('/')[2..]
      format_parts = []
      format_parts << 'https://github.com'
      format_parts << filepath_split[0..1]
      format_parts << %w[tree main]
      format_parts << filepath_split[2..]
      format_parts.join('/')
    end
  end
end
