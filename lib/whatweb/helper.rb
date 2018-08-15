# frozen_string_literal: true
require "digest/md5"
require "sanitize"

module WhatWeb
  module Helper
    refine HTTP::Response do
      def md5sum
        Digest::MD5.hexdigest(body.to_s)
      end

      def sanitized_body
        Sanitize.document(body.to_s, elements: ["html"])
      end

      def tag_pattern
        # remove stuff between script and /script
        # don't bother with  !--, --> or noscript and /noscript
        inscript = false;

        body.to_s.scan(/<([^\s>]*)/).flatten.map do |x|
          x.downcase!
          r = nil
          r = x if inscript == false
          inscript = true if x == "script"
          (inscript = false; r = x) if x == "/script"
          r
        end.compact.join(",")
      end
    end
  end
end
