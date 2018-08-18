# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.2 # 2011-04-12 #
# Updated regex
##
WhatWeb::Plugin.define "WhatWeb-Plugin" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-10-16
  @version = "0.2"
  @description = "This plugin detects instances of WhatWeb plugins. If this plugin is returned then chances are the other results are false positives."

  # Plugin list: http://github.com/urbanadventurer/WhatWeb/tree/master/plugins/

  # Passive #
  def passive(target)
    m = []

    # Extract plugin details
    if target.body =~ /^# redistribution and commercial restrictions. Please see the WhatWeb/ || target.body =~ /^# This file is part of WhatWeb and may be subject to/

      # Extract version
      if /^version "([^\"]+)"/.match?(target.body)
        m << { version: target.body.scan(/^version "([^\"]+)"/) }
      end

      # Extract plugin name
      if /^WhatWeb::Plugin.define "([^\"]+)" do/.match?(target.body)
        m << { string: target.body.scan(/^WhatWeb::Plugin.define "([^\"]+)" do/) }
      end

      # Extract modules
      if /^def ([a-z]+)[\s]?$/.match?(target.body)
        m << { module: target.body.scan(/^def ([a-z]+)[\s]?$/) }
      end

    end

    # Return passive matches
    m
  end
end
