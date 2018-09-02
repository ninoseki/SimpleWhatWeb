# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##

WhatWeb::Plugin.define "PasswordField" do
  @author = "Caleb Anderson"
  @version = "0.1"
  @description = "find password fields"

  # Matches #
  @matches = [

    { name: "input type", regexp: /<input [^>]*?type=["']password["'][^>]*>/i },

  ]

  # Passive #
  def passive(target)
    m = []
    fields = target.body.scan(/<input [^>]*?type=["']password["'][^>]*>/i)
    fields.each do |field|
      name = begin
               field.scan(/name=["'](.*?)["']/i).first.first
             rescue StandardError
               nil
             end
      m << { name: "field name", string: name } if name
    end
    m
  end
end
