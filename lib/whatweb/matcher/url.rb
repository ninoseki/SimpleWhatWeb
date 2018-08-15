module WhatWeb
  module Matcher
    class URL < Base
      attr_reader :url
      def initialize(target, match)
        super(target, match)
        @url = match[:url].to_s
      end

      def is_relative?
        url.match?(/^\//)
      end

      def has_query?
        url.match?(/\?/)
      end

      def match?
        if is_relative? && !has_query?
          target.uri.path.match? /#{url}$/
        elsif is_relative? && has_query?
          "#{target.uri.path}?#{target.uri.query}".match? /#{url}$/
        elsif !is_relative? && has_query?
          "#{target.uri.path}?#{target.uri.query}" == url
        else
          # !is_relative? && !has_query?
          target.uri.path == url
        end
      end
    end
  end
end