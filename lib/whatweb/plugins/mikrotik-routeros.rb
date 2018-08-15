# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "MikroTik-RouterOS" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-08-07
  @version = "0.1"
  @description = "RouterOS is the operating system used on the MikroTik RouterBOARD series of routers. It can also be installed on a PC and will turn it into a router with all the necessary features - routing, firewall, bandwidth management, wireless access point, backhaul link, hotspot gateway, VPN server and more."
  @website = "http://www.mikrotik.com/software.html & http://www.routerboard.com/"

  # Google results as at 2011-08-07 #
  # 14 for intitle:"RouterOS router configuration page" +RouterOS "You have connected to a router"

  # Dorks #
  @dorks = [
    'intitle:"RouterOS router configuration page" "RouterOS" "You have connected to a router"'
  ]

  # Matches #
  @matches = [

    # webfig
    { url: "/webfig/iframe.html", text: '<body onload="parent.generateContent(parent.location.hash.substr(1));">' },

  ]

  # Passive #
  def passive(target)
    m = []

    # Logo HTML
    if /<a href="http:\/\/mikrotik\.com"><img src="mikrotik_logo\.png" style="float: right;" \/><\/a>/.match?(target.body)

      m << { name: "Logo HTML" }

      # Version Detection
      if target.body =~ /<h1>RouterOS v([^\s^<]+)<\/h1>/
        m << { version: $1.to_s }
      end

      # Telnet Detection
      if target.body =~ /<label>(Telnet)<\/label>/
        m << { module: $1.to_s }
      end

      # Webbox Detection
      if target.body =~ /<label>(Webbox)<\/label>/
        m << { module: $1.to_s }
      end

    end

    # Return passive matches
    m
  end
end
