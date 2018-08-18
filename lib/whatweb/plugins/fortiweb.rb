# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "FortiWeb" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-05-14
  @version = "0.1"
  @description = "The FortiWeb family of Web application and XML firewalls protect, balance, and accelerate Web applications, databases, and the information exchanged between them."
  @website = "http://www.fortinet.com/products/fortiweb/"

  # ShodanHQ results as at 2011-05-14 #
  # 985 for FortiWeb

  # Matches #
  @matches = [

    # HTTP Server Header
    { search: "headers[server]", regexp: /^FortiWeb$/ },

    # Version Detection
    { search: "headers[server]", version: /^FortiWeb-([\d\.]+)$/ },

  ]
end
