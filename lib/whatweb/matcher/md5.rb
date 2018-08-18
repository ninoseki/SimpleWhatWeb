# frozen_string_literal: true

module WhatWeb
  module Matcher
    class MD5 < Base
      def match?
        target.md5sum == match[:md5]
      end
    end
  end
end
