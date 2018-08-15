# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##

##
WhatWeb::Plugin.define "Content-Language" do
  @author = "Peter van der Laan"
  @version = "0.1"
  @description = "Detect the content-language setting from the HTTP header."

  # Passive #
  def passive(target)
    m = []

    # HTTP Server Header # Content-Language
    unless target.headers["content-language"].nil? || target.headers["content-language"].empty?

      # Language Detection
      m << { string: target.headers["content-language"].to_s }
    end

    # Return passive match
    m
  end
end
