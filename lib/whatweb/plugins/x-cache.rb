# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "X-Cache" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-01-30
  @version = "0.1"
  @description = "This plugin identifies the X-Cache HTTP header and extracts the value."

  # ShodanHQ results as at 2011-01-30 #
  #  3,883 for x-cache-Lookup -squid
  # 59,766 for x-cache
  # 95,263 for x-cache-Lookup

  # Passive #
  def passive(target)
    m = []

    # X-Cache
    if /(MISS|HIT|NONE) from ([^\r^\n]{1,128})/.match?(target.headers["x-cache"])
      #    target.headers["x-cache"].each do |x_cache|
      m << { string: target.headers["x-cache"].to_s.scan(/ from ([^\r^\n]{1,128})/).flatten }
      #    end
    end

    # X-Cache-Lookup
    if /(MISS|HIT|NONE) from ([^\r^\n]{1,128})/.match?(target.headers["x-cache-lookup"])
      #    target.headers["x-cache-lookup"].each do |x_cache|
      m << { string: target.headers["x-cache-lookup"].scan(/ from ([^\r^\n]{1,128})/).flatten }
      #    end
    end

    # Return passive matches
    m
  end
end
