# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "ISC-SCADA-Service" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-11-01
  @version = "0.1"
  @description = "ISC SCADA Service"

  # 2 ShodanHQ results for "Server: ISC SCADA Service HTTPserv" @ 2010-11-01

  # Passive #
  def passive(target)
    m = []

    # Check HTTP Server
    if /ISC SCADA Service HTTPserv:00001/.match?(target.headers["server"])

      # HTTP Server Header
      m << { name: "HTTP Server Header" }

      # Default Title
      m << { text: "<title>ISC SCADA</title>" }

      # Default frame message
      m << { text: '<p>To take full advantage of this web-interface, you must use a frame compatible browser.</p>' }

      # Default Logo
      m << { md5: "3f0d5432fc1a54d284d17939431acf8a", url: "/gif/top.gif" }

      # Firmware # /html/info.htm
      m << { url: "/html/info.htm", firmware: target.body.scan(/<td bgcolor="#b4c0cb"><b>&nbsp;Firmware Version&nbsp;<\/b><\/td>[\r\n\s]*<td bgcolor="#f1eee9"> ([\d\.]+) &nbsp;<\/td>/).flatten } if target.body =~ /<td bgcolor="#b4c0cb"><b>&nbsp;Firmware Version&nbsp;<\/b><\/td>[\r\n\s]*<td bgcolor="#f1eee9"> ([\d\.]+) &nbsp;<\/td>/

      # Version # /html/info.htm
      m << { url: "/html/info.htm", version: target.body.scan(/<td bgcolor="#b4c0cb"><b>&nbsp;Script Version&nbsp;<\/b><\/td>[\r\n\s]*<td bgcolor="#f1eee9"> ([\d\.]+) &nbsp;<\/td>/).flatten } if target.body =~ /<td bgcolor="#b4c0cb"><b>&nbsp;Script Version&nbsp;<\/b><\/td>[\r\n\s]*<td bgcolor="#f1eee9"> ([\d\.]+) &nbsp;<\/td>/

      # MAC Address # /html/info.htm
      m << { url: "/html/info.htm", string: target.body.scan(/<TD bgcolor="#b4c0cb"><b>&nbsp;MAC-adresse&nbsp;<\/b><\/TD>[\r\n\s]*<TD bgcolor="#f1eee9"> ([^<]+)<\/TD>/).flatten } if target.body =~ /<TD bgcolor="#b4c0cb"><b>&nbsp;MAC-adresse&nbsp;<\/b><\/TD>[\r\n\s]*<TD bgcolor="#f1eee9"> ([^<]+)<\/TD>/

    end

    m
  end

  # Aggressive #
  def aggressive(target)
    m = []

    # Check Server
    if /ISC SCADA Service HTTPserv:00001/.match?(target.headers["server"])

      # HTTP Server Header
      m << { name: "HTTP Server Header" }

      url = URI.join(target.uri.to_s, "/html/info.htm").to_s
      new_target = WhatWeb::Target.new(url)

      # Firmware # /html/info.htm
      m << { url: "/html/info.htm", firmware: new_target.body.scan(/<td bgcolor="#b4c0cb"><b>&nbsp;Firmware Version&nbsp;<\/b><\/td>[\r\n\s]*<td bgcolor="#f1eee9"> ([\d\.]+) &nbsp;<\/td>/).flatten } if new_target.body =~ /<td bgcolor="#b4c0cb"><b>&nbsp;Firmware Version&nbsp;<\/b><\/td>[\r\n\s]*<td bgcolor="#f1eee9"> ([\d\.]+) &nbsp;<\/td>/

      # Version # /html/info.htm
      m << { url: "/html/info.htm", version: new_target.body.scan(/<td bgcolor="#b4c0cb"><b>&nbsp;Script Version&nbsp;<\/b><\/td>[\r\n\s]*<td bgcolor="#f1eee9"> ([\d\.]+) &nbsp;<\/td>/).flatten } if new_target.body =~ /<td bgcolor="#b4c0cb"><b>&nbsp;Script Version&nbsp;<\/b><\/td>[\r\n\s]*<td bgcolor="#f1eee9"> ([\d\.]+) &nbsp;<\/td>/

      # MAC Address # /html/info.htm
      m << { url: "/html/info.htm", string: new_target.body.scan(/<TD bgcolor="#b4c0cb"><b>&nbsp;MAC-adresse&nbsp;<\/b><\/TD>[\r\n\s]*<TD bgcolor="#f1eee9"> ([^<]+)<\/TD>/).flatten } if new_target.body =~ /<TD bgcolor="#b4c0cb"><b>&nbsp;MAC-adresse&nbsp;<\/b><\/TD>[\r\n\s]*<TD bgcolor="#f1eee9"> ([^<]+)<\/TD>/

    end

    m
  end
end
