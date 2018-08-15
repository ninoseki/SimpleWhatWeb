# frozen_string_literal: true

require "json"
require "thor"

module WhatWeb
  class CLI < Thor
    desc "start URL", "start a scan against a given URL"
    def scan(url)
      with_error_handling do
        hash = execute_plugins(url)
        puts hash.to_json
      end
    end

    no_commands do
      def execute_plugins(url)
        plugins = PluginManager.instance.load_plugins
        target = Target.new(url)

        results = {}
        plugins.each do |name, plugin|
          result = plugin.execute(target)
          results[name] = result unless result.empty?
        end
        results
      end

      def with_error_handling
        yield
      rescue => e
        puts "Warning: #{e}"
      end
    end
  end
end
