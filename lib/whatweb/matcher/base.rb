# frozen_string_literal: true

module WhatWeb
  module Matcher
    class Base
      attr_reader :target, :match
      def initialize(target, match)
        @target = target
        @match = match
      end

      def match?
        compiled_regexp.match? search_context
      rescue NoHeaderError => _
        false
      end

      def search_context
        search = match[:search]
        context = target.body
        case search
        when "all"
          context = target.raw_response
        when "header"
          context = target.raw_headers
        when /headers\[(.*)\]/
          k = $1.downcase
          header = target.headers[k]
          raise NoHeaderError, "There is no #{k} header in the response" unless header
          context = header
        end
        context.to_s
      end

      def compiled_regexp
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def self.match?(target, match)
        new(target, match).match?
      end
    end
  end
end
