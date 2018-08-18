# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Java-Password-Log" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-10-15
  @version = "0.1"
  @description = "This plugin detects Java password.log files and retrieves the usernname, password and URL."

  # 68 results for password END_FILE ext:log @ 2010-10-15

  # Dorks #
  @dorks = [
    'password END_FILE ext:log'
  ]

  # Extract username, password and URL
  def passive(target)
    m = []

    if /END_FILE/.match?(target.body)

      if /^name: = "([^\"]+)";[\r]?\npassword: = "([^\"]+)";[\r]?\nURL: = "([^\"]+)";/.match?(target.body)
        modules = target.body.scan(/^name: = "([^\"]+)";[\r]?\npassword: = "([^\"]+)";[\r]?\nURL: = "([^\"]+)";/)
        m << { module: modules }
      end

    end

    m
  end
end
