# frozen_string_literal: true

require "http"

require "whatweb/version"
require "whatweb/errors"

require "whatweb/helper"
using WhatWeb::Helper

require "whatweb/target"
require "whatweb/matcher"
require "whatweb/plugin"
require "whatweb/cli"

require "thread/pool"

module WhatWeb
  def self.execute_plugins(url, options = {})
    user_agent = options[:user_agent] || "WhatWeb/#{VERSION}"
    is_aggressive = options[:is_aggressive] || false
    max_threads = options[:max_threads] || 10

    plugins = PluginManager.instance.load_plugins
    target = Target.new(url, user_agent: user_agent)

    pool = Thread.pool(max_threads)
    results = {}
    plugins.each do |name, plugin|
      pool.process do
        result = plugin.execute(target, is_aggressive)
        results[name] = result unless result.empty?
      end
    end
    pool.shutdown
    results
  end

  def self.plugin_names
    plugins = PluginManager.instance.load_plugins
    plugins.map do |name, plugin|
      {
        name: name,
        author: plugin.author.encode("UTF-8"),
        description: plugin.description.encode("UTF-8"),
        website: plugin.website,
        version: plugin.version
      }
    end
  end
end
