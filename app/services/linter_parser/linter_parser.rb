# frozen_string_literal: true

require_relative 'rubocop_parser'
require_relative 'eslint_parser'

module LinterParser
  def self.parse(language, data)
    parser = case language
             when 'Ruby'
               RubocopParser
             when 'JavaScript'
               EslintParser
             else
               raise "Unsupported linter: #{language}"
             end
    parsed_data = JSON.parse(data)
    parser.parse(parsed_data)
  end
end
