# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.2 # 2012-01-08 #
# Added logo image matches
# Added www-authenticate header match
##
WhatWeb::Plugin.define "Billion-Router" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-08-05
  @version = "0.2"
  @description = "Billion router"
  @website = "http://www.billion.com/product/product.html"

  # ShodanHQ results as at 2012-01-08 #
  # 41,859 for Authenticate WebAdmin Conexant-EmWeb
  #  1,462 for Billion Sky

  # Matches #
  @matches = [

    # /customized/logo.gif
    { url: "/customized/logo.gif", md5: "766b7266a7324317b84be0d15cffc4aa" },
    { url: "/customized/logo.gif", md5: "82b6dea5a084044bf65f9af5440dfaf1" },

  ]

  # Passive #
  def passive(target)
    m = []

    # WWW-Authenticate: Basic realm="Billion Sky"
    if /Basic realm="Billion Sky"/.match?(target.headers["www-authenticate"])
      m << { name: "WWW-Authenticate" }
    end

    # WWW-Authenticate: Basic realm="WebAdmin" # Server: =~ Conexant-EmWeb
    if target.headers["www-authenticate"] =~ /Basic realm="WebAdmin"/ && target.headers["server"] =~ /Conexant-EmWeb/
      m << { name: "WWW-Authenticate", certainty: 25 }
    end

    # Return passive matches
    m
  end
end
