# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Essentia-Web-Server" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-08-06
  @version = "0.1"
  @description = "Essentia Web Server - High performance HTTP/1.1 compliant multi-threaded server."

  # Passive #
  def passive(target)
    m = []

    # Version Detection # HTTP Server Header
    if target.headers["server"] =~ /^Essentia\/([^\s]+)$/
      m << { version: $1.to_s }
    end

    # Return passive matches
    m
  end
end
