# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.2 # 2011-06-11
# Added account detection
##
WhatWeb::Plugin.define "Polycom-SoundPoint" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-03-14
  @version = "0.2"
  @description = "Polycom SoundPoint VOIP phone"
  @website = "http://www.polycom.com/products/voice/desktop_solutions/soundpoint/"

  # ShodanHQ results as at 2011-03-14 #
  # 6,474 for Polycom SoundPoint IP Telephone HTTPd

  # Google results as at 2011-06-11 #
  # 4 for "SoundPoint IP Configuration" intitle:"SoundPoint IP Configuration Utility - Registration" ext:htm

  # Dorks #
  @dorks = [
    '"SoundPoint IP Configuration" intitle:"SoundPoint IP Configuration Utility - Registration" ext:htm'
  ]

  # Passive #
  def passive(target)
    m = []

    # HTTP Server Header
    if /^Polycom SoundPoint IP Telephone HTTPd$/.match?(target.headers["server"])

      m << { name: "HTTP Server Header" }

      # Display Name
      m << { url: "/reg_1.htm", string: target.body.scan(/<td width="200" bgcolor="#999999"><input value="([^"]+)" name="reg\.1\.displayName"\/><\/td>/).flatten } if target.body =~ /<td width="200" bgcolor="#999999"><input value="([^"]+)" name="reg\.1\.displayName"\/><\/td>/

      # Account Detection
      if target.body =~ /<td width="200" bgcolor="#999999"><input value="([^"]+)" name="reg\.1\.auth\.userId"\/><\/td>/ && target.body =~ /<td width="200" bgcolor="#999999"><input value="([^"]*)" type="password" name="reg\.1\.auth\.password"\/><\/td>/
        m << { url: "/reg_1.htm", account: target.body.scan(/<td width="200" bgcolor="#999999"><input value="([^"]+)" name="reg\.1\.auth\.userId"\/><\/td>/).to_s + ":" + target.body.scan(/<td width="200" bgcolor="#999999"><input value="([^"]*)" type="password" name="reg\.1\.auth\.password"\/><\/td>/).flatten }

      end

    end

    # Return passive matches
    m
  end
end
