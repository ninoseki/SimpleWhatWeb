# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Java-Management-Extensions" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-10-15
  @version = "0.1"
  @description = "Java Management Extensions (JMX) is a Java technology that supplies tools for managing and monitoring applications, system objects, devices (e. g. printers) and service oriented networks. - info: http://en.wikipedia.org/wiki/Java_Management_Extensions"

  @matches = [

    # Timestamp
    { regexp: /[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]+ [DEBUG|INFO]/ },

  ]

  def passive(target)
    m = []

    # Extract URL
    if /jmx.url=([^,^\}^\s]+)/.match?(target.body)
      version = target.body.scan(/jmx.url=([^,^\}^\s]+)/)[0][0]
      m << { version: version }
    end

    # Extract username and password
    if target.body =~ /jmx.username=([^,^\}^\s^\n]+)/ && target.body =~ /jmx.password=([^,^\}^\s^\n]+)/
      modules = target.body.scan(/jmx.username=([^,^\}^\s^\n]+)/)[0][0] + ":" + target.body.scan(/jmx.password=([^,^\}^\s^\n]+)/)[0][0]
      m << { module: modules }
    end

    m
  end
end
