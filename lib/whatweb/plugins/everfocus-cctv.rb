# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "EverFocus-CCTV" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-04-08
  @version = "0.1"
  @description = "EverFoxus CCTV router web interface"
  @website = "http://www.everfocus.com/products.cfm"

  # Default Logins:
  # EverFocus - PowerPlex - admin:admin
  # EverFocus - PowerPlex - supervisor:supervisor
  # EverFocus - PowerPlex - operator:operator

  # ShodanHQ results as at 2011-04-08 #
  # 5,871 for http server/everfocus

  # Matches #
  @matches = [

    # Redirect page
    { regexp: /^	If the page is not redirected, please click <a href="\/login\.html\?[\d]{4}&1">here<\/a><br>$/ },

    # HTML Comment
    { text: '<!--mei20071101 input type="image" name="recMode" style="visibility:hidden" src="stoprec.gif" onclick="changeRecordMode()"-->' },

  ]

  # Passive #
  def passive(target)
    m = []

    # HTTP Server Header
    if /^http server\/everfocus$/.match?(target.headers["server"])

      m << { name: "HTTP Server Header" }

      # HTML Comment
      if /<!--Version [\d]{8} for [\d\.]+ EF -->/.match?(target.body)

        # Version Detection
        m << { version: target.body.scan(/^<!--Version [\d]{8} for ([\d\.]+) EF -->/).flatten }

        # Firmware Build/Year Detection
        m << { firmware: target.body.scan(/^<!--Version ([\d]{8}) for [\d\.]+ EF -->/).flatten }

      end

      # ERViewer.ocx Version Detection # JavaScript
      m << { module: "ERViewer.ocx/" + target.body.scan(/var g_sVersion = "([\d\.]+)"/).flatten } if target.body =~ /var g_sVersion = "[\d\.]+"/

    end

    # Return passive matches
    m
  end
end
