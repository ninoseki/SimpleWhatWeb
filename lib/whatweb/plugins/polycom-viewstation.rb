# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Polycom-ViewStation" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-03-11
  @version = "0.1"
  @description = "Polycom ViewStation - video server"
  @website = "http://www.polycom.com/"

  # ShodanHQ results as at 2011-03-11 #
  # 4,489 for Viavideo-Web

  # Passive #
  def passive(target)
    m = []

    # HTTP Server Header
    if /^Viavideo-Web$/.match?(target.headers["server"])

      # Server: Viavideo-Web
      m << { name: "HTTP Server Header" }

      # Model Detection # /model.js
      m << { url: "/model.js", model: target.body.scan(/^var model="([^"]{2,10})";$/) } if target.body =~ /^var model="[^"]{2,10}";$/

      # Version Detection # /u_indexmain.htm
      m << { url: "/u_indexmain.htm", version: target.body.scan(/<td> <span class="bigtextwhite">Release ([^\-]{3,10}) - [\d]{2} [A-Z]{1}[a-z]{2,3} [\d]{4}<\/span>/) } if target.body =~ /<td> <span class="bigtextwhite">Release ([^\-]{3,10}) - [\d]{2} [A-Z]{1}[a-z]{2,3} [\d]{4}<\/span>/

    end

    # Return passive matches
    m
  end
end
