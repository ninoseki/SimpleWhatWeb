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
WhatWeb::Plugin.define "RapidSite" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-03-08
  @version = "0.2"
  @description = "RapidSite is the world's largest and most experienced Web hosting entity."
  @website = "http://www.rapidsite.net/"

  # ShodanHQ results as at 2011-03-08 #
  # 166,648 for Rapidsite/Apa
  #
  #  United States 101,473
  #  Japan 55,903
  #  Germany 7,032
  #  Switzerland 1,138
  #  Spain 1,100

  @matches = [
    # HTTP Server Header
    { regexp: /^Rapidsite/, search: "headers[server]" },

  ]

  # Passive #
  def passive(target)
    m = []

    # HTTP Server Header
    if /^Rapidsite\/Apa\/([\d\.]+)/.match?(target.headers["server"])
      m << { string: "Apache/" + target.headers["server"].scan(/Rapidsite\/Apa\/([\d\.]+)/).flatten }
    elsif /^Rapidsite\/Apa$/.match?(target.headers["server"])
      m << { string: "Apache" }
    end

    # Return passive matches
    m
  end
end
