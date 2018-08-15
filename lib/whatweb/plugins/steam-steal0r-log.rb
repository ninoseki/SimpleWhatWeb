# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Steam-Steal0r-Log" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-10-15
  @version = "0.1"
  @description = "This plugin extracts passwords from Steam Steal0r logs."

  # 4 results for "Possible Accountnames:" "Steam Steal0r v2" @ 2010-10-15

  # Extract passwords
  def passive(target)
    m = []

    if /^--------------------[\s]+Steam Steal0r v2 by -=Player=-/.match?(target.body)

      if /^ Possible Accountnames: [^\r^\n]+[\s]+Password: ([^\r^\n]+)/.match?(target.body)
        accounts = target.body.scan(/^ Possible Accountnames: [^\r^\n]+[\s]+Password: ([^\r^\n]+)/)
        m << { account: accounts }
      end

    end

    m
  end
end
