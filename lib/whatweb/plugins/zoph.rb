# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.2 #
# Fixed regex
##
WhatWeb::Plugin.define "Zoph" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-07-11
  @version = "0.2"
  @description = "Zoph (Zoph Organizes Photos) is a web based digital image presentation and management system. In other words, a photo album. It is built with PHP, MySQL and Perl."
  @website = "http://www.zoph.org/"

  # Google results as at 2010-07-10 #
  # 26 for inurl:albums.php inurl:parent_album_id

  # Dorks #
  @dorks = [
    'inurl:albums.php inurl:parent_album_id'
  ]

  @matches = [

    # Default menu HTML
    { text: '<li class="selected"><a href="zoph.php">home</a></li><li ><a href="albums.php">albums</a></li><li ><a href="categories.php">categories</a></li><li >' },

    # Default title
    { text: "<title>Zoph - Home</title>" },

  ]

  def passive(target)
    m = []

    # new versions
    if /        <p class="version">/.match?(target.body)
      if /            Zoph ([\d\.a-zA-Z\-]+)/.match?(target.body)
        version = target.body.scan(/            Zoph ([\d\.a-zA-Z\-]+)/)[0][0]
        m << { version: version }
      end
    end

    # old versions
    if /          <td colspan="2" align="center">/.match?(target.body)
      if /            <font size="-1">Zoph ([\d\.a-zA-Z\-]+)<\/font>/.match?(target.body)
        version = target.body.scan(/            <font size="-1">Zoph ([\d\.a-zA-Z\-]+)<\/font>/)[0][0]
        m << { version: version }
      end
    end

    m
  end
end
