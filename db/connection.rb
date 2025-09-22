# frozen_string_literal: true

require 'erb'
require 'yaml'
require 'active_record'

module DB
  module Connection
    def self.establish_connection
      yaml_content = ERB.new(File.read('db/config.yml')).result
      db_config = YAML.load(yaml_content)

      ActiveRecord::Base.establish_connection(db_config)
    end
  end
end
