# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.6 # 2011-03-19 # Brendan Coles <bcoles@gmail.com>
# Added aggressive match for /administrator/
# Updated matches to remove false positives
##
# Version 0.5 # 2011-03-06 # Brendan Coles <bcoles@gmail.com>
# Updated module detection
##
# Version 0.4 by Andrew Horton
# added matches suggested by Aung Khant including 'meta name="description' and /<a href="[^"]*index.php\?option=com_/ from the Joomla plugin
##
# Version 0.3
# Andrew Horton added examples, changed time since epoch match for less false positives with Joomla, added mosvisitor cookie match
# Aung Khant(http://yehg.net) added description, README.php match, Mambo Admin match
##
# Version 0.2
# removed :name & :certainty
##
WhatWeb::Plugin.define "Mambo" do
  @author = "Andrew Horton"
  @version = "0.6"
  @description = "Mambo CMS (http://mambo-foundation.org)"

  # Google results as at 2011-03-06 #
  # 3,420,000 results for "powered by mambo" inurl:option=com_content

  # Matches #
  @matches = [

    # Meta Generator
    { regexp: /<meta name="Generator" content="Mambo - Copyright 2000 - [0-9]+ Miro International Pty Ltd.  All rights reserved." \/>/ },

    # Meta Description
    { regexp: /<meta name="description" content="Mambo - the dynamic portal engine and content management system" \/>/ },

    # README.php
    { url: 'README.php', text: 'Mambo is OSI Certified Open Source Software, released under the GNU General Public License' },

    # administrator/templates/mambo_admin/templateDetails.xml
    { url: 'administrator/templates/mambo_admin/templateDetails.xml', regexp: /(<name>Mambo Admin<\/name>|<authorUrl>http:\/\/www\.mambo\-foundation\.org<\/authorUrl>)/ },

  ]

  # Passive #
  def passive(target)
    m = []

    # /administrator/ # Confirm the presence of Mambo with 100% certainty
    if target.uri.path =~ /\/administrator\// && (target.body =~ /<div id="mambo"><img src="[^"]*\/images\/header_text.png" alt="Mambo Logo" \/><\/div>/ || target.body =~ /<a href="http:\/\/mambo-foundation.org">Mambo<\/a> is Free Software released under the GNU\/GPL License.<\/div>/ || target.body =~ /<title>[^<]+ Administration \[Mambo( Open Source)?\]<\/title>/)
      m << { name: "Mambo Administration Page" }
    end

    # HTML Comment # seconds since epoch # Also used by joomla
    if target.body =~ /<\/html>.*(\n)*<!-- [0-9]+.*-->(\n)*\z/ && target.body !~ /joomla/i
      m << { name: "seconds since epoch in html comment after </html>", certainty: 25 }
    end

    # Module Detection # Doesn't work in SEO mode # Also used by joomla
    if /<a href="[^"]*index.php\?option=(com_[^&^"]+)/.match?(target.body)

      # Absolute URL
      m << { certainty: 75, module: target.body.scan(/<a href="https?:\/\/#{Regexp.escape(target.uri.host)}[^"]*index.php\?option=(com_[^&^"]+)/) } if target.body =~ /<a href="https?:\/\/#{Regexp.escape(target.uri.host)}[^"]*index.php\?option=(com_[^&^"]+)/

      # Relative URL
      m << { certainty: 75, module: target.body.scan(/<a href="[^"^:]*index.php\?option=(com_[^&^"]+)/) } if target.body =~ /<a href="[^"^:]*index.php\?option=(com_[^&^"]+)/

    end

    # mosvisitor cookie # Also used by joomla
    m << { certainty: 75, name: "mosvisitor cookie" } if target.headers["set-cookie"] =~ /mosvisitor=[0-9]+/

    # Return passive matches
    m
  end

  # Aggressive #
  def aggressive(target)
    m = []

    # Open base_uri + /administrator/
    new_target = WhatWeb::Target.new(target.uri.to_s + "/administrator/")

    # Confirm the presence of Mambo with 100% certainty
    if new_target.body =~ /<div id="mambo"><img src="[^"]*\/images\/header_text.png" alt="Mambo Logo" \/><\/div>/ || new_target.body =~ /<a href="http:\/\/mambo-foundation.org">Mambo<\/a> is Free Software released under the GNU\/GPL License.<\/div>/ || new_target.body =~ /<title>[^<]+ Administration \[Mambo( Open Source)?\]<\/title>/
      m << { name: "Mambo Administration Page" }
    end

    # Return aggressive matches
    m
  end
end
