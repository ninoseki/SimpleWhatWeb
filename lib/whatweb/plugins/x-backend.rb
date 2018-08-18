# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "X-Backend" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-02-16
  @version = "0.1"
  @description = "This plugin identifies and extracts the value for X-Backend, X-Backend-Server, X-BackendHost and X-Backend-Host from the HTTP headers."

  # ShodanHQ results as at 2011-02-16 #
  # 66 for X-Backend-Server
  # 4 for X-BackendHost
  # 3 for X-Backend-Host

  # Passive #
  def passive(target)
    m = []

    # HTTP Header # X-Backend
    m << { string: target.headers["x-backend"].to_s } unless target.headers["x-backend"].nil?

    # HTTP Header # X-Backend-Server
    m << { string: target.headers["x-backend-server"].to_s } unless target.headers["x-backend-server"].nil?

    # HTTP Header # X-BackendHost
    m << { string: target.headers["x-backendhost"].to_s } unless target.headers["x-backendhost"].nil?

    # HTTP Header # X-Backend-Host
    m << { string: target.headers["x-backend-host"].to_s } unless target.headers["x-backend-host"].nil?

    # Return passive matches
    m
  end
end
