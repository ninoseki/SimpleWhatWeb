# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "x-hacker" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-04-08
  @version = "0.1"
  @description = "This plugin identifies the X-Hacker HTTP header and returns its value."

  # ShodanHQ results as at 2011-04-08 #
  # 23 for x-hacker

  # Passive #
  def passive(target)
    m = []

    # X-Hacker HTTP Header
    m << { string: target.headers["x-hacker"] } unless target.headers["x-hacker"].nil?

    # Return passive matches
    m
  end
end
