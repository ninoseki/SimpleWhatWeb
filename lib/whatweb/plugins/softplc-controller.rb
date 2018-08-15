# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "SoftPLC-Controller" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-06-02
  @version = "0.1"
  @description = "All SoftPLC controller CPUs provide the same rich set of features. Every SoftPLC is a high-performance, feature-rich Programmable Automation Controller (PAC), combining the functions of a proprietary PLC with the benefits of both an open architecture design and computer technologies."
  @website = "http://www.softplc.com/products.php"

  # ShodanHQ results as at 2011-06-02 #
  # 81 for SoftPLC

  # Passive #
  def passive(target)
    m = []

    # No HTTP Server Header
    if target.headers["server"].nil?

      # Location
      if @status.to_s =~ /^302$/ && target.headers["location"] =~ /\/syswww\/login\.xml/
        m << { name: "Location Header" }
      end

      # SoftPLC Cookie
      m << { name: "SoftPLC Cookie" } if target.headers["set-cookie"] =~ /^SoftPLC=-?[\d]+; Path=\//

    end

    # Return passive matches
    m
  end
end
