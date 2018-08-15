# frozen_string_literal: true

module WhatWeb
  module Matcher
    class GHDB < Base
      attr_reader :query
      def initialize(target, match)
        super(target, match)
        @query = match[:ghdb].to_s
      end

      def match_intitle?
        # extract either the next word or the following words enclosed in "s, it can't possibly be both
        intitle = (query.scan(/intitle:"([^"]*)"/i) + query.scan(/intitle:([^"]\w+)/i)).flatten.join("|")
        return false if intitle.empty?
        target.body.match? /<title>[^<]*#{Regexp.escape(intitle)}[^<]*<\/title>/i
      end

      def match_filetype?
        filetype = (query.scan(/filetype:"([^"]*)"/i) + query.scan(/filetype:([^"]\w+)/i)).flatten.join("|")
        return false if filetype.empty?
        base_uri = target.uri.to_s.split("?").first
        base_uri.match? /#{Regexp.escape(filetype)}$/i
      end

      def match_inurl?
        inurl = (query.scan(/inurl:"([^"]*)"/i) + query.scan(/inurl:([^"]\w+)(\.*)(\w*)/i)).flatten
        return false if inurl.empty?
        # can occur multiple times.
        inurl.all? { |x| target.uri.to_s.match? /#{Regexp.escape(x)}/i }
      end

      def query_for_others
        s = query
        s = s.gsub(/intitle:"([^"]*)"/i, '').gsub(/intitle:([^"]\w+)/i, '')
        s = s.gsub(/filetype:"([^"]*)"/i, '').gsub( /filetype:([^"]\w+)/i, '')
        s = s.gsub(/inurl:"([^"]*)"/i, '').gsub(/inurl:([^"]\w+)(\.*)(\w*)/i, '')
        s
      end

      def match_others?
        words = query_for_others.scan(/([^ "]+)|("[^"]+")/i).flatten.compact.each { |w| w.delete!('"') }.sort.uniq
        return false if words.empty?
        words.all? do |w|
          # does it start with a - ?
          if w[0] == '-'
            # reverse true/false if it begins with a -
            !target.sanitized_body.match? /#{Regexp.escape(w[1..-1])}/i
          else
            w = w[1..-1] if w[0] == '+' # if it starts with +, ignore the 1st char
            target.sanitized_body.match? /#{Regexp.escape(w)}/i
          end
        end
      end

      def match?
        matches = []
        # does it contain intitle?
        matches << match_intitle? if /intitle:/i.match?(query)
        matches << match_filetype? if /filetype:/i.match?(query)
        matches << match_inurl? if /inurl:/i.match?(query)
        matches << match_others?
        # if all matcbhes are true, then true
        matches.uniq == [true]
      end
    end
  end
end
