# frozen_string_literal: true

require_relative 'linter_helpers'

module LinterParser
  class RubocopParser
    extend LinterHelpers

    def self.parse(data)
      files = {}
      summary = {}
      data['files'].each do |file|
        next if file['offenses'].empty?

        path = normalize_path_to_github(file['path'])
        files[path] = []
        file['offenses'].each do |offense|
          files[path] << {
            message: offense['message'],
            line: offense['location']['line'],
            column: offense['location']['column'],
            identifier: offense['cop_name']
          }
        end
      end
      summary['offense_count'] = data['summary']['offense_count']
      {
        files: files,
        summary: summary
      }
    end
  end
end
