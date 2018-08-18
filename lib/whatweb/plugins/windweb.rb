# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "WindWeb" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-10-26
  @version = "0.1"
  @description = "WindWeb Webserver"

  # About 21746 ShodanHQ results for "server: WindWeb" @ 2010-10-26

  # HTTP Header
  def passive(target)
    m = []

    # Server
    m << { version: target.headers["server"].to_s.scan(/^[\s]*WindWeb\/([^\s^\r^\n]+)/i).flatten } if target.headers["server"].to_s =~ /^[\s]*WindWeb\/([^\s^\r^\n]+)/i

    m
  end
end
