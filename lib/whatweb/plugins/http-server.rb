# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
#
# Version 0.4 # 2011-04-08 # Brendan Coles <bcoles@gmail.com>
# Updated OS detection
##
# Version 0.3 # 2011-02-21 # Brendan Coles <bcoles@gmail.com>
# Added OS detection
##
# Version 0.2
# removed :probability
##
WhatWeb::Plugin.define "HTTPServer" do
  @author = "Andrew Horton"
  @version = "0.4"
  @description = "HTTP server header string. This plugin also attempts to identify the operating system from the server header."

  # Passive #
  def passive(target)
    m = []

    unless target.headers["server"].nil?

      # OS Detection # Windows family
      m << { os: "Windows (32 bit)" } if target.headers["server"] =~ /Win32/i
      if /Windows/i.match?(target.headers["server"])
        m << { os: "Windows Vista" } if target.headers["server"] =~ /Windows Vista/i
        m << { os: target.headers["server"].scan(/(Windows [0-9]{4})/i) } if target.headers["server"] =~ /Windows [0-9]{4}/i
        m << { os: target.headers["server"].scan(/(Windows Server [0-9]{4})/i) } if target.headers["server"] =~ /Windows Server [0-9]{4}/i
        m << { os: "Windows XP" } if target.headers["server"] =~ /Windows XP/i
        m << { os: "Windows" } if m.empty?
      end

      # OS Detection # Unix family
      m << { os: "MontaVista Hard Hat Linux" } if target.headers["server"] =~ /MontaVista Software Hard Hat Linux/i
      m << { os: "FreeBSD" } if target.headers["server"] =~ /FreeBSD/i
      m << { os: "MacOSX" } if target.headers["server"] =~ /MacOSX/i
      m << { os: "CentOS" } if target.headers["server"] =~ /CentOS/i
      m << { os: "Debian Linux" } if target.headers["server"] =~ /Debian/i
      m << { os: "Ubuntu Linux" } if target.headers["server"] =~ /Ubuntu/i
      m << { os: "Mandrake Linux" } if target.headers["server"] =~ /Mandrake/i
      m << { os: "PCLinuxOS" } if target.headers["server"] =~ /PCLinuxOS/i
      m << { os: "Fedora Linux" } if target.headers["server"] =~ /Fedora/i
      m << { os: "openSUSE" } if target.headers["server"] =~ /openSUSE/i
      m << { os: "Arch Linux" } if target.headers["server"] =~ /Arch Linux/i
      m << { os: "Mandriva Linux" } if target.headers["server"] =~ /Mandriva Linux/i
      m << { os: "SUSE Linux" } if target.headers["server"] =~ /Linux\/SUSE/i
      m << { os: "Slackware Linux" } if target.headers["poweredby"] =~ /Slackware/i
      m << { os: "Gentoo Linux" } if target.headers["x-powered-by"] =~ /Gentoo/i
      m << { os: "Red Hat Linux" } if target.headers["server"] =~ /Red[-| ]?Hat/i
      m << { os: "GNU OpenSolaris" } if target.headers["server"] =~ /GNU_OpenSolaris/i
      m << { os: "Trustix Secure Linux" } if target.headers["server"] =~ /Trustix Secure Linux/i

      # Unix catch-all
      if m.empty? && target.headers["server"] =~ /UNIX/i
        m << { os: "Unix" }
      end

      # Solaris catch-all
      if m.empty? && target.headers["server"] =~ /Solaris/i
        m << { os: "Solaris" }
      end

      # Linux catch-all # Kernel Version Detection
      if m.empty? && target.headers["server"] =~ /Linux\/[^\s]+/
        m << { os: target.headers["server"].scan(/(Linux\/[^\s]+)/) }
      elsif m.empty? && target.headers["server"] =~ /Linux/
        m << { os: "Linux" }
      end

      # Return server string
      m << { name: "server string", string: target.headers['server'].to_s }

    end

    # Return passive matches
    m
  end
end
