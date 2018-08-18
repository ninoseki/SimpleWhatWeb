# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Apache-CouchDB" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-08-03
  @version = "0.1"
  @description = "Apache CouchDB is a document-oriented database written in Erlang that can be queried and indexed in a MapReduce fashion using JavaScript. CouchDB provides a RESTful JSON API than can be accessed from any environment that allows HTTP requests."
  @website = "http://couchdb.apache.org/"

  # More Info #
  # http://en.wikipedia.org/wiki/CouchDB
  # http://www.erlang.org/doc/

  # ShodanHQ results as at 2011-08-03 #
  # 41 for CouchDB

  # Passive #
  def passive(target)
    m = []

    # HTTP Server Header
    if target.headers["server"] =~ /^CouchDB\/([^\s]+) \((Erlang OTP\/R[^\s^\)]+)\)$/
      m << { version: $1.to_s }
      m << { string: $2.to_s }
    end

    # Return passive matches
    m
  end
end
