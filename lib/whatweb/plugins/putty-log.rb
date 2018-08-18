# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "PuTTY-Log" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-10-15
  @version = "0.1"
  @description = "This plugin identifies instances of PuTTY log files and attempts to extract usernames, servers and software versions."

  # 91 results for "=~=~=~=~=~=~=~=~=~=~=~= PuTTY log " ext:log @ 2010-10-15

  @matches = [

    # Log header
    { regexp: /=~=~=~=~=~=~=~=~=~=~=~= PuTTY log [0-9]{4}.[0-9]{2}.[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} =~=~=~=~=~=~=~=~=~=~=~=/ },

  ]

  # Extract username, server & software versions.
  def passive(target)
    m = []

    if /=~=~=~=~=~=~=~=~=~=~=~= PuTTY log [0-9]{4}.[0-9]{2}.[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} =~=~=~=~=~=~=~=~=~=~=~=/.match?(target.body)

      # Telnet
      if /^Connected to ([^\s]+)[\s]+Escape character is '\^\]'/.match?(target.body)
        modules = target.body.scan(/^Connected to ([^\s]+)[\s]+Escape character is '\^\]'/)
        m << { module: modules }
      end

      # SSH
      if /^([0-9a-zA-Z\-\.\@_]+)'s password:/.match?(target.body)
        modules = target.body.scan(/^([0-9a-zA-Z\-\.\@_]+)'s password:/)
        m << { module: modules }
      elsif /^login as: ([0-9a-zA-Z\-\._]+)/.match?(target.body)
        modules = target.body.scan(/^login as: ([0-9a-zA-Z\-\._]+)/)
        m << { module: modules }
      end

      if /^Event Log: Writing new session log \(SSH packets mode\) to file: /.match?(target.body)
        if /^Event Log: Looking up host "([^\"]+)"/.match?(target.body)
          account = target.body.scan(/^Event Log: Looking up host "([^\"]+)"/)
          m << { account: account }
        end
        if /^Event Log: Server version:[\s]+([^\s]+)/.match?(target.body)
          version = target.body.scan(/^Event Log: Server version:[\s]+([^\s]+)/)
          m << { version: version }
        end
      end

    end

    m
  end
end
