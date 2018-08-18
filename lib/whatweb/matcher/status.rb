module WhatWeb
  module Matcher
    class Status < Base
      attr_reader :status
      def initialize(target, match)
        super(target, match)
        @status = match[:status].to_i
      end

      def match?
        status == target.status
      end
    end
  end
end