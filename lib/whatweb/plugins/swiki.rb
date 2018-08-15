# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Swiki" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-08-24
  @version = "0.1"
  @description = "Swiki is a popular implementation of Ward Cunningham's WikiWikiWeb that runs under Comanche."
  @website = "http://wiki.squeak.org/swiki/"

  # Google results as at 2011-08-24 #
  # 39 for "powered by Squeak" "Squeak * :: Comanche * :: Swiki"

  # Dorks #
  @dorks = [
    '"powered by Squeak" "Squeak * :: Comanche * :: Swiki"'
  ]

  # Matches #
  @matches = [

    # Aggressive # /defaultScheme/comSwiki.gif
    { url: "/defaultScheme/comSwiki.gif", md5: "81d538bed9f676fffbdaedb9d95cdbc1" },

  ]

  # Passive #
  def passive(target)
    m = []

    # Version Detection # Squeak / Comanche / Swiki
    if target.body =~ /<a href="http:\/\/minnow\.cc\.gatech\.edu\/swiki" title="ComSwiki: powered by Squeak"><img src="[^"^>]*\/defaultScheme\/comSwiki\.gif" border=0 width=277 height=88 alt="ComSwiki: powered by Squeak"><\/a><br>[\s]*<em>(Squeak [^\s]+) :: (Comanche [^\s]+) :: Swiki ([^\s]+)<\/em>/
      m << { string: $1.to_s }
      m << { string: $2.to_s }
      m << { version: $3.to_s }
    end

    # Return passive matches
    m
  end
end
