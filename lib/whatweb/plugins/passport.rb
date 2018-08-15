# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Passport" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-01-09
  @version = "0.1"
  @description = "This plugin detects instances of Microsoft Live Passport servers using the MSNSERVER, X-MSNSERVER and PPServer HTTP headers."
  # More info: http://code.entersources.com/f/Generate-Valid-MSNP9-ClientTicket_2_3254_0.aspx

  # 1036 ShodanHQ results for MSNSERVER @ 2011-01-09
  # 214 ShodanHQ results for PPServer @ 2011-01-09

  # Passive #
  def passive(target)
    m = []

    # PPServer HTTP Header # Retrieve local host name
    m << { string: target.headers["ppserver"].to_s.scan(/H: ([\w\-\.]+) /).flatten } if target.headers["ppserver"] =~ /H: ([\w\-\.]+) /

    # MSNServer HTTP Header # Retrieve local host name
    m << { string: target.headers["msnserver"].to_s.scan(/H: ([\w\-\.]+) /).flatten } if target.headers["msnserver"] =~ /H: ([\w\-\.]+) /

    # X-MSNServer HTTP Header # Retrieve local host name
    m << { string: target.headers["x-msnserver"].to_s } unless target.headers["x-msnserver"].nil?

    m
  end
end
