# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "FITELnet-Router" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-03-30
  @version = "0.1"
  @description = "FITELnet router"
  @website = "http://www.furukawa.co.jp/fitelnet/"

  # ShodanHQ results as at 2011-03-30 #
  # 4,374 for GR-HTTPD Server
  # Most results are from Japan

  # Passive #
  def passive(target)
    m = []

    # HTTP Server Header
    if /^GR-HTTPD Server\/([\d\.]+)$/.match?(target.headers["server"])

      m << { certainty: 75, name: "HTTP Server Header" }

      # Model Detection # Title
      m << { model: target.body.scan(/<TITLE> FITELnet-([A-Z][\d]+) [^>]+<\/TITLE>$/) } if target.body =~ /<TITLE> FITELnet-([A-Z][\d]+) [^>]+<\/TITLE>$/

      # MAC Detection
      m << { string: target.body.scan(/<TITLE> FITELnet-[A-Z][\d]+ [^>]+\(([\da-f:]{17})\)<\/TITLE>$/) } if target.body =~ /<TITLE> FITELnet-[A-Z][\d]+ [^>]+\(([\da-f:]{17})\)<\/TITLE>$/

    end

    # Return passive matches
    m
  end
end
