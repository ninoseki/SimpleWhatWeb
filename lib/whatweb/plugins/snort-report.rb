# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Snort-Report" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-10-10
  @version = "0.1"
  @description = "Snort Report is an add-on module for the Snort Intrusion Detection System. It provides realtime reporting from the MySQL database generated by Snort. It requires a platform with MySQL 3.23, PHP 4.0, and Snort 1.8"
  @website = "http://www.symmetrixtech.com/"

  # Google results as at 2011-10-10 #
  # 4 for intitle:"SNORT Report" inurl:"alerts.php"

  # Dorks #
  @dorks = [
    'intitle:"SNORT Report" inurl:"alerts.php"'
  ]

  # Matches #
  @matches = [

    # Version Detection # Footer
    { version: /<br><br><br><br>Snort Report Version ([^<]+)<br>Copyright 2000-20[\d]{2}, <a href="http:\/\/www\.symmetrixtech\.com">Symmetrix Technologies, LLC\.<\/a><\/td>/ },

    # sigdetail.php
    { text: '<title>SNORT Report - Signature Detail ()</title>' },

  ]
end
