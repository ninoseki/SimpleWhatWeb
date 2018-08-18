# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Tilgin-Router" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-08-04
  @version = "0.1"
  @description = "Tilgin router"
  @website = "http://www.tilgin.com/Products/"

  # Default Credentials
  #
  # Model                              Credentials
  # HG1311 (Tilgin Firmware)           admin:admin
  # HG1351 (Tilgin Firmware)           admin:admin
  # Vood 342 (Tilgin Swedish Firmware) Conf:admin
  # Vood 452W (Tilgin Firmware)        Conf:admin
  # Vood 453W (Tilgin German Firmware) admin:admin

  # Google results as at 2011-08-04 #
  # 109 for "Welcome to the Tilgin router" "Status summary" intitle:VOOD
  #  59 for "Welcome to the Tilgin router" "Status summary" intitle:VOOD -www.killmail.org

  # Dorks #
  @dorks = [
    '"Welcome to the Tilgin router" "Status summary" intitle:VOOD -www.killmail.org'
  ]

  # Matches #
  @matches = [

    # h1 heading
    { text: '<H1 id="title">Welcome to the Tilgin router</H1>' },

    # Title
    { text: '<TITLE>VOOD</TITLE>', url: "/" },

    # Wizard link
    { text: '<A href="/wizard/" class="" title="Wizard">Run wizard</A> for a quick and simple initial configuration.' },

    # Menu
    { text: '<A href="/status/" class="menuitem" title="Status">Status</A><SPAN class="separator"> </SPAN><A href="/help/" class="last menuitem" title="Help">Help</A>' },

    # StyleSheet
    { text: '<LINK rel="stylesheet" type="text/css" href="/compressed-control.css">' },

  ]

  # Passive #
  def passive(target)
    m = []

    if /<TABLE class="control">[\s]+<TBODY>[\s]+<TR>[\s]+<TD class="first">Product name:<\/TD>/.match?(target.body)

      # Model Detection
      if target.body =~ /<TABLE class="control">[\s]+<TBODY>[\s]+<TR>[\s]+<TD class="first">Product name:<\/TD>[\s]+<TD class="last">([^\s]+)<\/TD>[\s]+<\/TR>[\s]+<TR>[\s]+<TD class="first">/
        m << { model: $1.to_s }
      end

      # Firmware Version Detection
      if target.body =~ /<TR>[\s]+<TD class="first">Software revision:<\/TD>[\s]+<TD class="last">([^\s]+)<\/TD>[\s]+<\/TR>[\s]+<TR>[\s]+<TD class="first">Connection:<\/TD>/
        m << { firmware: $1.to_s }
      end

    end

    # Return passive matches
    m
  end
end
