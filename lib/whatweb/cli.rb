# frozen_string_literal: true

require "json"
require "thor"

require "thread/pool"

module WhatWeb
  class CLI < Thor
    desc "scan URL", "Scan against a given URL"
    method_option :aggressive, type: :boolean, default: false
    method_option :user_agent, type: :string
    method_option :max_threads, type: :numeric, default: 10
    def scan(url)
      user_agent = options[:user_agent]
      is_aggressive = options[:aggressive]
      max_threads = options[:max_threads]

      with_error_handling do
        hash = WhatWeb.execute_plugins(url, user_agent: user_agent, is_aggressive: is_aggressive, max_threads: max_threads)
        puts hash.to_json
      end
    end

    desc "list_plugins", "List all plugins"
    def list_plugins
      with_error_handling do
        puts WhatWeb.plugin_names.to_json
      end
    end

    no_commands do
      def with_error_handling
        yield
      rescue StandardError => e
        puts "Warning: #{e}"
      end
    end
  end
end
