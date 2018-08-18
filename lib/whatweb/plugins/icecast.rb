# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Icecast" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-08-07
  @version = "0.1"
  @description = "Icecast is a GPL streaming media server project that currently streams in MP3 format."
  @website = "http://www.icecast.org/"

  # ShodanHQ results as at 2011-08-07 #
  # 75 for icecast

  # Passive #
  def passive(target)
    m = []

    # Version Detection # HTTP Server Header
    if target.headers["server"] =~ /^Icecast ([^\s]+)/
      m << { version: $1.to_s }
    end
    if target.headers["server"] =~ /^icecast\/([^\s]+)/
      m << { version: $1.to_s }
    end

    # icy-name Header
    m << { string: target.headers["icy-name"].to_s } unless target.headers["icy-name"].nil?

    # WWW-Authenticate Header
    m << { certainty: 75, name: "WWW-Authenticate Header" } if target.headers["www-authenticate"] =~ /Basic realm="Icecast/

    # Return passive matches
    m
  end
end
