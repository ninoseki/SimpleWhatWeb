# frozen_string_literal: true

require "require_all"
require "singleton"

module WhatWeb
  class Plugin
    attr_reader :name, :author, :version, :description, :website, :matches, :dorks
    def initialize(name, &block)
      @name = name
      @locked = false
      instance_eval(&block)
      startup
    end

    def self.define(name, &block)
      plugin = new(name, &block)
      PluginManager.instance.add_plugin plugin
      plugin
    end

    def version_detection?
      matches.any? { |match| match.key? :version }
    end

    # individual plugins can override this
    def startup; end

    # individual plugins can override this
    def shutdown; end

    def passive(_target)
      []
    end

    def aggressive(_target)
      []
    end

    def lock
      @locked = true
    end

    def unlock
      @locked = false
    end

    def locked?
      @locked
    end

    def randstr
      rand(36**8).to_s(36)
    end

    def matchers(target, match)
      {
        ghdb:         Matcher::GHDB.new(target, match),
        text:         Matcher::Text.new(target, match),
        md5:          Matcher::MD5.new(target, match),
        tag_pattern:  Matcher::TagPattern.new(target, match),
        regexp:       Matcher::Common.new(target, match),
        account:      Matcher::Common.new(target, match),
        version:      Matcher::Common.new(target, match),
        os:           Matcher::Common.new(target, match),
        module:       Matcher::Common.new(target, match),
        model:        Matcher::Common.new(target, match),
        string:       Matcher::Common.new(target, match),
        firmware:     Matcher::Common.new(target, match),
        filepath:     Matcher::Common.new(target, match),
      }
    end

    def matching(target, match)
      results = []
      matchers(target, match).each do |key, matcher|
        next unless match.key?(key) && matcher.match?
        results << match
        # if a matcher is the common matcher, replace the key's value to the regexp match result
        results.last[key] = matcher.match_results if common_matcher?(matcher)
      end
      # return results if there is any match so far
      return results if results
      # if url and status are present, they must both match
      # url and status cannot be alone. there must be something else that has already matched
      results << match if Matcher::Status.match?(target, match)
      results << match if Matcher::URL.match?(target, match)
      results
    end

    def execute(target, is_aggressive = false)
      results = []
      results += matches.map { |match| matching(target, match) } if matches
      results += passive(target)
      results += aggressive(target) if is_aggressive
      # TODO: aggressive mode support
      results.flatten!
      results.compact!
      results.each { |result| result[:certainty] = 100 unless result.key?(:certainty) }
      results
    end

    private

    def common_matcher?(matcher)
      matcher.class == WhatWeb::Matcher::Common
    end
  end

  class PluginManager
    include Singleton
    attr_reader :registered_plugins
    def initialize
      @registered_plugins = {}
    end

    def add_plugin(plugin)
      @registered_plugins[plugin.name] = plugin
      plugin
    end

    def load_plugins
      load_rel "./plugins/*.rb"
      registered_plugins
    end

    def self.load_plugins
      instance.load_plugins
    end

    def self.registered_plugins
      instance.registered_plugins
    end
  end
end
