# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "I-O-DATA-Router" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-08-05
  @version = "0.1"
  @description = "I-O DATA router [Japanese] - http://www.iodata.jp/product/"

  # ShodanHQ results as at 2011-08-05 #
  # 413 for WN-GDN Ver
  # All results are from Japan

  # Google results as at 2011-08-05 #
  # 8 for intitle:"I-O DATA Wireless Broadband Router"

  # Dorks #
  @dorks = [
    'intitle:"I-O DATA Wireless Broadband Router"'
  ]

  # Matches #
  @matches = [

    # Model Detection # Title
    { url: "/", model: /<title>I-O DATA Wireless Broadband Router (WN-[^\s^<]+)<\/title>/ },

  ]

  # Passive #
  def passive(target)
    m = []

    # Version + Model Detection # HTTP Server Header
    if target.headers["server"] =~ /^Linux, HTTP\/1\.1, (WN-[^\s]+) Ver ([^\s]+)$/
      m << { model: $1.to_s }
      m << { version: $2.to_s }
    end

    # Return passive matches
    m
  end
end
