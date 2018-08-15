# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.2 # 2016-04-23 # Andrew Horton
# Moved patterns from passive function to matches[]
##
WhatWeb::Plugin.define "OKI-Printer" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-05-31
  @version = "0.2"
  @description = "OKI printer"
  @website = "http://www.okiprintingsolutions.com/"

  # ShodanHQ results as at 2011-05-31 #
  # 240 for OKIDATA-HTTPD

  @matches = [
    # HTTP Server Header
    { regexp: /^OKIDATA-HTTPD/, search: "headers[server]" },

    # Version
    { version: /^OKIDATA-HTTPD\/([^\s]+)$/, search: "headers[server]" },

  ]

  # Passive #
  def passive(target)
    m = []

    # HTTP Server Header
    if /^OKIDATA-HTTPD\/([^\s]+)$/.match?(target.headers["server"])

      # Model Detection
      m << { model: target.body.scan(/<title>([^<]+)<\/title>/) } if target.body =~ /<title>([^<]+)<\/title>/

    end

    # Return passive matches
    m
  end
end

# An aggressive plugin could retrieve additional information from /status.htm
# Including MAC address, active services (web/snmp), serial number, version, etc
