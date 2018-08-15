# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##

# Version 0.2
# removed :certainty=>100

WhatWeb::Plugin.define "RedirectLocation" do
  @author = "Andrew Horton"
  @version = "0.2"
  @description = "HTTP Server string location. used with http-status 301 and 302"

  def passive(target)
    m = []

    unless target.headers.nil?
      location = nil
      location = target.headers["location"] if target.headers.key?("location")

      unless location.nil?
        m << { name: "location", string: location }
      end
    end

    m
  end
end
