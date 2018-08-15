# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.2 # 2011-03-06 #
# Updated OS detection
##
WhatWeb::Plugin.define "Java" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-01-28
  @version = "0.2"
  @description = "Java allows you to play online games, chat with people around the world, calculate your mortgage interest, and view images in 3D, just to name a few. It's also integral to the intranet applications and other e-business solutions that are the foundation of corporate computing."
  @website = "http://www.java.com/"

  # ShodanHQ results as at 2011-01-28 #
  #  10,814 for X-Powered-By: JSP
  #  153,488 for JSESSIONID
  #  571 for java.vendor=Sun Microsystems Inc
  #  47 for java.vendor=IBM Corporation
  #  118 for "x-powered-by" JSP JRE
  #  13950 for server JAVA

  # Passive #
  def passive(target)
    m = []

    # JSESSIONID Cookie
    m << { name: "JSESSIONID Cookie" } if target.headers["set-cookie"] =~ /JSESSIONID=[^;]{0,32};[\s]?path=\//i

    # X-Powered-By # JSP Version Detection
    m << { version: target.headers['x-powered-by'].scan(/JSP\/([\d\.]+)/) } if target.headers['x-powered-by'] =~ /JSP\/([\d\.]+)/
    # X-Powered-By # Servlet Version Detection
    m << { string: target.headers['x-powered-by'].scan(/(Servlet\/[\d\.]+)/i) } if target.headers['x-powered-by'] =~ /(Servlet\/[\d\.]+)/i
    # X-Powered-By # JRE Version Detection
    m << { string: target.headers['x-powered-by'].scan(/(JRE\/[\d\.\-\_]+)/) } if target.headers['x-powered-by'] =~ /(JRE\/[\d\.\-\_]+)/

    # Server # Version Detection
    m << { version: target.headers['server'].scan(/java\/([\d\.\-\_]+)/) } if target.headers['server'] =~ /java\/([\d\.\-\_]+)/
    # Server # JDK Version Detection
    m << { string: target.headers['server'].scan(/(JDK [\d\.\-\_]+)/) } if target.headers['server'] =~ /(JDK [\d\.\-\_]+)/

    # Servlet-Engine
    if /\((.*?); (.*?); Java (.*?); (.*?); java.vendor=[^\)]{0,50}\)/.match?(target.headers['servlet-engine'])

      # JSP Version Detection
      m << { string: target.headers['servlet-engine'].scan(/\((.*?); (.*?); Java (.*?); (.*?); java.vendor=[^\)]{0,50}\)/)[0][0] }
      # Servlet Version Detection
      m << { string: target.headers['servlet-engine'].scan(/\((.*?); (.*?); Java (.*?); (.*?); java.vendor=[^\)]{0,50}\)/)[0][1] }
      # Version Detection
      m << { version: target.headers['servlet-engine'].scan(/\((.*?); (.*?); Java (.*?); (.*?); java.vendor=[^\)]{0,50}\)/)[0][2] }
      # OS Detection
      m << { os: target.headers['servlet-engine'].scan(/\((.*?); (.*?); Java (.*?); (.*?); java.vendor=[^\)]{0,50}\)/)[0][3] }

    end

    # Return passive matches
    m
  end
end
