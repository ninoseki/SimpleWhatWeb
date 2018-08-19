# frozen_string_literal: true

module WhatWeb
  module Matcher
    class Version
      attr_reader :name, :versions, :files, :url, :best_versions
      def initialize(name_product = nil, versions = nil, url = nil)
        raise ArgumentError, 'You must specify the name of the product' if name_product.nil?
        raise ArgumentError, 'You must specify the available versions of the product' if versions.nil?
        raise ArgumentError, 'You must specify the available url of the website' if url.nil?

        @name = name_product
        @versions = versions
        @files = { 'filenames' => [], 'files' => [], 'md5' => [] }
        @url = url
        @best_versions = []

        versions.each do |_version, value|
          # e.g. key => "5.0.0"
          # e.g. value => [["login.php", "59a69886a8c006d607369865f1b4a28c"]]]
          value.each do |filename, _md5|
            next if @files['filenames'].include? filename
            @files['filenames'] << filename

            url = URI.join(@url.to_s, filename.to_s)
            @files['files'] << url

            target = Target.new(url)
            @files['md5'] << target.md5sum
          end
        end
      end

      def match?(filename, md5)
        idx = files['filenames'].index(filename)
        @files['md5'][idx] == md5
      end

      def best_match
        versions.max { |x, y| x[1].length <=> y[1].length }
      end

      def matches_format
        return [] if versions.empty?
        version, _files = best_match
        [version]
      end
    end
  end
end
