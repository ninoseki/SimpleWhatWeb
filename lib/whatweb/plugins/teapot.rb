# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Teapot" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-03-14
  @version = "0.1"
  @description = "HTCPCP, a protocol for controlling, monitoring, and diagnosing coffee pots."
  @website = "http://www.apps.ietf.org/rfc/rfc2324.html"

  # ShodanHQ results as at 2011-03-14 #
  # 6 for 418 teapot

  # Passive #
  def passive(target)
    m = []

    # HTCPCP 418 Status Code
    if @status == 418
      m << if /<title>([^<]+)<\/title>/i.match?(target.body)
             { string: target.body.scan(/<title>([^<]+)<\/title>/i) }
           else
             { string: "I'm a teapot" }
           end
    end

    # Return passive matches
    m
  end
end
