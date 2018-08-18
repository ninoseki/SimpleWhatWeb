# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##

WhatWeb::Plugin.define "Samsung-Printer" do
  @author = "Andrew Horton"
  @version = "0.1"
  @description = "Samsung. SyncThru Web Service - Embedded Web Server"

  @matches = [
    { text: 'var debugMode = ("$$GSI_TCPIP_IP_ADDR$$".indexOf(".")' }
  ]
end
