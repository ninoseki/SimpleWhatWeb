# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##

# Version 0.2
# removed :certainty=>100 & :name

WhatWeb::Plugin.define "TypoLight" do
  @author = "Andrew Horton"
  @version = "0.2"
  @description = "TypoLight is an OpenSource CMS written in PHP"
  @website = "www.typolight.org"

  @matches = [
    { name: "typolight.css", text: '<link rel="stylesheet" href="system/typolight.css" type="text/css" media="screen" />' },
    { text: 'This website is powered by TYPOlight Open Source CMS :: Licensed under GNU/LGPL' },
    { text: '<!-- indexer::continue -->' }
  ]

  # /typolight page
  # <title>Hydro Energie Roth :: TYPOlight Open Source CMS 2.8</title>
  # TYPOlight webCMS :: TYPOlight webCMS 2.7

  def aggressive(target)
    m = []

    url = URI.join(target.uri.to_s, "/typolight/").to_s
    new_target = WhatWeb::Target.new(url)

    if /<title>[^<]+TYPOlight[^<]+CMS ([^<]+)<\/title>/.match?(new_target.body)
      version = new_target.body.scan(/<title>[^<]+TYPOlight[^<]+CMS ([^<]+)<\/title>/)[0][0]
      m << { name: "login page version", version: version }
    end
    m
  end
end
