# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "LEAP" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-03-15
  @version = "0.1"
  @description = "LEAP is a Content Management System (LEAP CMS), yet so much more than this. Because of its wide range of features that go beyond content management, it is also referred to as a Website Operating System."
  @website = "http://www.leapcms.com/"

  # Google results as at 2011-03-15 #
  # 113 for inurl:LEAP/error.lasso

  # Dorks #
  @dorks = [
    'inurl:LEAP/error.lasso'
  ]

  # Matches #
  @matches = [

    # Version Detection # Meta Generator
    { version: /<meta name="Generator" content="LEAP ([\d\.]+)"( \/)?>/ },

    # Version Detection # Meta Formatter
    { version: /<meta name="Formatter" content="LEAP ([\d\.]+)"( \/)?>/ },

  ]

  # Passive #
  def passive(target)
    m = []

    if target.uri.host
      # window.location = host/LEAP/error.lasso JavaScript
      if target.body&.match?(Regexp.new('if \(ls == lw.length\) window.location = "http[s]?:\/\/' + Regexp.escape(target.uri.host) + '\/LEAP\/error.lasso";'))
        m << { name: "/LEAP/error.lasso JavaScript" }
      end
    end
    # /LEAP/ # 401 # www-authenticate
    if (@status == 401) && target.headers["www-authenticate"] =~ /^Basic realm="LEAP"$/ && target.uri.path =~ /^\/LEAP\//
      m << { name: "/LEAP/ www-authenticate" }
    end

    # Return passive matches
    m
  end
end
