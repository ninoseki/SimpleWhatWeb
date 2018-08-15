# frozen_string_literal: true

module WhatWeb
  module Matcher
    class Common < Base
      def key
        @key ||= keys.find { |k| match.key? k }
      end

      def keys
        %i[regexp account os module model string firmware filepath]
      end

      def match_results
        @match_results ||= [].tap do |out|
          regexp_matches = search_context.scan(compiled_regexp)
          out << regexp_matches.map do |regexp_match|
            if regexp_match.is_a?(Array)
              regexp_match[offset || 0]
            else
              regexp_match
            end
          end
        end.flatten.compact.sort.uniq
      end

      def match?
        return false unless match[key].class == Regexp
        begin
          !match_results.empty?
        rescue NoHeaderError => _
          false
        end
      end

      def offset?
        match[:offset]
      end

      def offset
        match[:offset]
      end

      def compiled_regexp
        match[key].class == Regexp ? match[key] : Regexp.new(Regexp.escape(match[key].to_s))
      end
    end
  end
end
