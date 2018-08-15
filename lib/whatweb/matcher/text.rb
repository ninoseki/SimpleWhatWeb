# frozen_string_literal: true

module WhatWeb
  module Matcher
    class Text < Base
      attr_reader :text
      def initialize(target, match)
        super(target, match)
        @text = match[:text].to_s
      end

      def compiled_regexp
        Regexp.new Regexp.escape(text)
      end
    end
  end
end
