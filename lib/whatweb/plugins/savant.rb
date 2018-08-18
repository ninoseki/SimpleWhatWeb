# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Savant" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-08-06
  @version = "0.1"
  @description = "Savant is a freeware open source web server that runs on Windows 9x, ME, NT, 2000, and XP."
  @website = "http://savant.sourceforge.net/"

  # ShodanHQ results as at 2011-08-06 #
  # 65 for Savant

  # Passive #
  def passive(target)
    m = []

    # Version Detection # HTTP Server Header
    if target.headers["server"] =~ /^Savant\/([^\s]+)$/
      m << { version: $1.to_s }
    end

    # Return passive matches
    m
  end
end
