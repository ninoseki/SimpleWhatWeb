# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "FreePBX" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-06-12
  @version = "0.1"
  @description = "FreePBX is an easy to use web based GUI (graphical user interface) that controls and manages Asterisk"
  @website = "http://www.freepbx.org/"

  # ShodanHQ results as at 2011-06-12 #
  # 10 for FreePBX http

  # Passive #
  def passive(target)
    m = []

    # WWW-Authenticate realm
    if /FreePBX/.match?(target.headers["www-authenticate"])
      m << { name: "WWW-Authenticate" } if target.headers["www-authenticate"] =~ /^Basic realm="FreePBX( Admin| Administration)?"/
      m << { name: "WWW-Authenticate" } if target.headers["www-authenticate"] =~ /^Digest realm="FreePBX"/
    end

    # Return passive matches
    m
  end
end
