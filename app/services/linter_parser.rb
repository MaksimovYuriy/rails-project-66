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

    class RubocopParser
        def self.parse(data)
            files = {}
            summary = { }
            data['files'].each do |file|
                if !file['offenses'].empty?
                    path = file['path']
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
            end
            summary['offense_count'] = data['summary']['offense_count']
            {
                files: files,
                summary: summary
            }
        end
    end

    class ESLintParser
        def self.parse(data)
            files = {}
            summary = {}
            offense_count = 0
            data.each do |file|
                offense_count += file['errorCount']
                offense_count += file['fatalErrorCount']
                offense_count += file['warningCount']

                path = file['filePath']
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