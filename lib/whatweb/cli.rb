# frozen_string_literal: true

require "json"
require "thor"

module WhatWeb
  class CLI < Thor
    desc "scan URL", "Scan against a given URL"
    method_options aggressive: :boolean, default: false
    def scan(url)
      is_aggressive = options[:aggressive]
      with_error_handling do
        hash = execute_plugins(url, is_aggressive)
        puts hash.to_json
      end
    end

    no_commands do
      def execute_plugins(url, is_aggressive = false)
        plugins = PluginManager.instance.load_plugins
        target = Target.new(url)

        results = {}
        plugins.each do |name, plugin|
          result = plugin.execute(target, is_aggressive)
          results[name] = result unless result.empty?
        end
        results
      end

      def with_error_handling
        yield
      rescue StandardError => e
        puts "Warning: #{e}"
      end
    end
  end
end
