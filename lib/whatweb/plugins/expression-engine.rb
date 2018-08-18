# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.2
# removed :name and :certainty=>100
##
WhatWeb::Plugin.define "ExpressionEngine" do
  @author = "Andrew Horton"
  @version = "0.2"
  @description = "ExpressionEngine is CMS written in PHP. Free and commercial versions"
  @website = "http://expressionengine.com"

  # Dorks #
  @dorks = [
    '"Powered by ExpressionEngine"'
  ]

  # Powered by <a href="http://expressionengine.com/">ExpressionEngine</a>   uncommon

  @matches = [
    { regexp: /owered by <a href="http:\/\/expressionengine.com\/">ExpressionEngine<\/a>/ }
  ]

  # Set-Cookie: exp_last_visit=959242411; expires=Mon, 23-May-2011 03:13:31 GMT; path=/
  # Set-Cookie: exp_last_activity=1274602411; expires=Mon, 23-May-2011 03:13:31 GMT; path=/
  # Set-Cookie: exp_tracker=a%3A1%3A%7Bi%3A0%3Bs%3A5%3A%22index%22%3B%7D; path=/

  def passive(target)
    m = []
    m << { name: "exp_last_visit cookie" } if target.headers["set-cookie"] =~ /exp_last_visit=/
    m
  end

  # these plugins only identify the system. they don't find out the version, etc
  def aggressive(target)
    m = []

    url = URI.join(target.uri.to_s, "READ_THIS_FIRST.txt").to_s
    new_target = WhatWeb::Target.new(url)

    if /ExpressionEngine/.match?(new_target.body)
      m << { name: "readthisfirst txt file" }
    end

    url = URI.join(target.uri.to_s, "system/updates/ee_logo.jpg").to_s
    new_target = WhatWeb::Target.new(url)

    if (new_target.status == 200) && new_target.body =~ /JFIF/
      m << { name: "ee_logo jpg" }
    end

    m
  end
end
