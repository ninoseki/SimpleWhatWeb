# frozen_string_literal: true

module WhatWeb
  module Matcher
    class TagPattern < Base
      attr_reader :tag_pattern
      def initialize(target, match)
        super(target, match)
        @tag_pattern = match[:tag_pattern]
      end

      def match?
        tag_pattern == target.tag_pattern
      end
    end
  end
end
