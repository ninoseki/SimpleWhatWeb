# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Intoto-Router" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-08-18
  @version = "0.1"
  @description = "Intoto router"
  @website = "http://www.intoto.com/"

  # ShodanHQ results as at 2011-08-18 #
  # 11,956 for Intoto Http Server

  # Google results as at 2011-08-18 #
  # 6 for intitle:"Device Manager" "To administer this device you must first login"

  # Dorks #
  @dorks = [
    'intitle:"Device Manager" "To administer this device you must first login"'
  ]

  # Matches #
  @matches = [

    # Model Detection # Also used by other manufacturers
    { certainty: 25, model: /<td class="headtext" nowrap>Router Model: (<font size=2>)?<b>([^\s^<]+)[\s]*(&nbsp;)?<\/b><\//, offset: 1 },

    # td class="greytitle"
    { text: '<td class="greytitle" nowrap><b>About Device Manager </b></td> ' },

    # Telnet link # Also used by other manufacturers
    { certainty: 25, text: '<td class="headtext" nowrap><font class="yellowbullet">&#149;</font> <a href="javascript:telnetToBox();">Telnet</a></td>' },

    # body HTML
    { regexp: /<body bgcolor=#E6E6E6 leftmargin=0 topmargin=0 marginheight=0 marginwidth=0 style="padding: [\d]{1,2}px" onload="javascript:usrnameFocus\(\);javascript:isValidBrowser\(\);/ },

    # Server Header
    { search: "headers[server]", version: /^Intoto Http Server v([^\s]+)$/ },

  ]
end
