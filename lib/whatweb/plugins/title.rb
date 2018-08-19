# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##

# Version 0.3 - 2014-08-22
# Remove newlines in title, give warning when newlines are found.
# Version 0.2
# removed :certainty=>100

require "nokogiri"

WhatWeb::Plugin.define "Title" do
  @author = "Andrew Horton"
  @version = "0.3"
  @description = "The HTML page title"

  def passive(target)
    m = []

    html = Nokogiri.parse(target.body)
    title = html.css("title")
    if title
      # Give warining if title element contains newline(s)
      m << { name: "WARNING", module: "Title element contains newline(s)!" } if title.text.include? "\n"
      # Strip all newlines in title string (for better output)
      m << { name: "page title", string: title.text.strip }
    end
    m
  end
end
