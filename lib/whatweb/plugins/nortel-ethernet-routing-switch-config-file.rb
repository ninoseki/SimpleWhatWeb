# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Nortel-Ethernet-Routing-Switch-Config-File" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-10-14
  @version = "0.1"
  @description = "Nortel Ethernet Routing Switch Config File"
  @website = "http://products.nortel.com/go/product_index.jsp?locale=en-US&lcid=-1"

  # 21 results for "qos queue-set-assignment queue-set" @ 2010-10-14

  def passive(target)
    m = []

    if /qos queue-set-assignment queue-set/.match?(target.body)

      # Get version
      if /^! Software version = v([\d\.]+)/.match?(target.body)
        version = target.body.scan(/^! Software version = v([\d\.]+)/)[0][0]
        m << { version: version }
      end

      # Get model
      if /^! Model = Ethernet Routing Switch ([^\r^\n]+)/.match?(target.body)
        model = target.body.scan(/^! Model = Ethernet Routing Switch ([^\r^\n]+)/)
        m << { model: model }
      end

    end

    m
  end
end
