# frozen_string_literal: true

require "digest/md5"
require "oga"

module WhatWeb
  module Helper
    refine HTTP::Response do
      def md5sum
        Digest::MD5.hexdigest(body.to_s)
      end

      def text
        doc = Oga.parse_html(body.to_s.force_encoding('UTF-8'))
        path = /\A<body(?:\s|>)/i.match?(body.to_s) ? '/html/body' : '/html/body/node()'
        nodes = doc.xpath(path)
        nodes.map(&:text).join
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
