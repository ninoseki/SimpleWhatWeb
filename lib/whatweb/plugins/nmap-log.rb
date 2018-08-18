# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.2 # 2011-03-22 #
# Updated regex
##
WhatWeb::Plugin.define "Nmap-Log" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-10-21
  @version = "0.2"
  @description = "This plugin identifies nmap plain-text logs and extracts the hostname, OS, active ports and nmap version. It does not work for logs in the XML file format."
  @website = "http://www.insecure.org/nmap/"

  # Google results as at 2010-10-21 #
  # 32 for "Starting nmap" "fyodor@insecure.org" (ext:txt | ext:log)

  # Passive #
  def passive(target)
    m = []

    # Extract details
    if target.body =~ /^Interesting ports on (.+):[\r]?$/ && target.body =~ /^Starting (n|N)map /

      # Version # Newer versions # 4.x
      m << { version: target.body.scan(/^Starting Nmap ([^\s]+) \( http:\/\/nmap.org \) at /) } if target.body =~ /^Starting Nmap ([^\s]+) \( http:\/\/nmap.org \) at /

      # Version # Older version # 2.x
      m << { version: target.body.scan(/^Starting nmap V. ([^\s]+) by fyodor@insecure.org/) } if target.body =~ /^Starting nmap V. ([^\s]+) by fyodor@insecure.org/

      # Target
      m << { string: "Target: " + target.body.scan(/^Interesting ports on (.+):[\r]?$/)[0][0] }

      # Operating System
      m << { string: "OS: " + target.body.scan(/^Remote operating system guess: ([^\r^\n]*)/)[0][0] } if target.body =~ /Remote operating system guess: ([^\r^\n]*)/

      # Ports
      if target.body =~ /Port[\s]+State[\s]+Service/i && target.body =~ /^([\d]{1,5})\/(udp|tcp)[\s]+open[\s]+([a-z]+)/

        target.body.scan(/^([\d]{1,5})\/(udp|tcp)[\s]+open[\s]+([a-z]+)/).each { |service| m << { string: service[0] + "(" + service[1] + ")(" + service[2] + ")" } if (service.size == 3) && service[0] =~ /[\d]{1,5}/ }

      end

    end

    # Return passive matches
    m
  end
end
