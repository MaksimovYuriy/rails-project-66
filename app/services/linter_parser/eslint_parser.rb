# frozen_string_literal: true

require_relative 'linter_helpers'

module LinterParser
  class ESLintParser
    extend LinterHelpers

    def self.parse(data)
      files = {}
      summary = {}
      offense_count = 0
      data.each do |file|
        offense_count += file['errorCount']
        offense_count += file['fatalErrorCount']
        offense_count += file['warningCount']

        path = normalize_path_to_github(file['filePath'])
        files[path] = []
        file['messages'].each do |message|
          files[path] << {
            message: message['message'],
            line: message['line'],
            column: message['column'],
            identifier: message['ruleId']
          }
        end
      end
      summary['offense_count'] = offense_count

      {
        files: files,
        summary: summary
      }
    end
  end
end
