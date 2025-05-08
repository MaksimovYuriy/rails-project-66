# frozen_string_literal: true

module LinterParser
  def self.parse(language, data)
    parser = case language
             when 'Ruby'
               RubocopParser
             when 'JavaScript'
               ESLintParser
             else
               raise "Unsupported linter: #{linter_type}"
             end
    parsed_data = JSON.parse(data)
    parser.parse(parsed_data)
  end

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
