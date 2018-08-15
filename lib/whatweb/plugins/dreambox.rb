# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.2 # 2016-04-19 # Andrew Horton
# Moved patterns from passive function to matches[]
##
WhatWeb::Plugin.define "Dreambox" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-05-30
  @version = "0.2"
  @description = "The Dreambox is a series of Linux-powered DVB satellite, terrestrial and cable digital television receivers (set-top box), produced by German multimedia vendor Dream Multimedia. Enigma2 WebInterface - Control a DreamBox using a Browser. The Dreambox Webinterface (short WebIf) is included in all newer Images. - More info: http://en.wikipedia.org/wiki/Dreambox"
  # More info on Enigma2: http://dream.reichholf.net/wiki/Enigma2:WebInterface

  # ShodanHQ results as at 2011-05-30 #
  # 5,104 for Enigma2 WebInterface Server
  # 2,372 for Enigma2 TwistedWeb realm
  #    24 for TwistedWeb realm dm

  # Matches #
  @matches = [

    # Aggressive # /web-data/img/favicon.ico
    { url: "/web-data/img/favicon.ico", md5: "d9aa63661d742d5f7c7300d02ac18d69" },

    # Version Detection # HTTP Server Header
    { version: /^Enigma2 WebInterface Server ([\d\.]+)$/, search: "headers[server]" },

    # HTTP Server Header
    { regexp: /^TwistedWeb/, search: "headers[server]" },

    # HTTP Server Header # Version Detection
    { version: /^TwistedWeb\/([\d\.]+)/, search: "headers[server]" },

  ]

  # Passive #
  def passive(target)
    m = []

    # HTTP Server Header # TwistedWeb
    if /^TwistedWeb/.match?(target.headers["server"])

      # WWW-Authenticate # basic realm="Enigma2 WebInterface"
      m << { name: "TwistedWeb server + WWW-Authenticate realm" } if target.headers["www-authenticate"] =~ /^basic realm="Enigma2 WebInterface"$/

      # Title
      m << { name: "TwistedWeb server + Title" } if target.body =~ /<title>Dreambox WebControl<\/title>/

    end

    # Model Detection # WWW-Authenticate: basic realm
    if target.headers["server"] =~ /^Twisted\/[\d\.]+/ && target.headers["www-authenticate"] =~ /^basic realm="(dm[\d]{4})"$/i
      m << { model: target.headers["www-authenticate"].scan(/^basic realm="(dm[\d]{4})"$/i) }
    end

    # Return passive matches
    m
  end
end
