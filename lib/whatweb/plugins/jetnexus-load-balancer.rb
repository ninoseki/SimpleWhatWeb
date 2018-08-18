# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "jetNEXUS-Load-Balancer" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-05-23
  @version = "0.1"
  @description = "jetNEXUS provide leading edge load balancing and traffic management solutions to accelerate application performance and availability, enabling clients to create and deliver resilient and scalable online services."
  @website = "http://www.jetnexus.com/"

  # ShodanHQ results as at 2011-05-23 #
  # 4 for jetNEXUS: Streaming Compression On

  # Passive #
  def passive(target)
    m = []

    # jetNEXUS Header
    m << { name: "jetNEXUS Header" } if target.headers["jetnexus"] =~ /^Streaming Compression/

    # Return passive matches
    m
  end
end
