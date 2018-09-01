# frozen_string_literal: true

module WhatWeb
  class Target
    using WhatWeb::Helper

    attr_accessor :response
    attr_reader :url, :body, :headers, :raw_headers, :raw_response, :status, :uri

    def initialize(url, response = nil)
      @url = url.to_s
      @response = response || open_url
      build
    end

    def open_url
      HTTP.get url
    end

    def build
      @body = response.body.to_s
      @headers = response.headers.to_a.map { |k, v| [k.downcase, v] }.to_h
      @headers["set-cookie"] = set_cookie if response.headers["Set-Cookie"]
      @raw_headers = response.headers.to_a.map { |h| h.join(":") }.join("\n")
      @raw_response = body + raw_headers
      @status = response.status
      @uri = response.uri
    end

    def set_cookie
      cookie = response.headers["Set-Cookie"]
      cookie.is_a?(String) ? cookie : cookie.join("\n")
    end

    def md5sum
      @md5sum ||= response.md5sum
    end

    def tag_pattern
      @tag_pattern ||= response.tag_pattern
    end

    def text
      @text ||= response.text
    end

    def self.meta_refresh_regex
      /<meta[\s]+http\-equiv[\s]*=[\s]*['"]?refresh['"]?[^>]+content[\s]*=[^>]*[0-9]+;[\s]*url=['"]?([^"'>]+)['"]?[^>]*>/i
    end
  end
end
