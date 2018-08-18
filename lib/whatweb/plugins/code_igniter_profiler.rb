# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##

WhatWeb::Plugin.define "CodeIgniterProfiler" do
  @author = "Caleb Anderson"
  @version = "0.1"
  @description = "Find codeigniter profiler debug divs"

  def passive(target)
    m = []
    if target.body =~ /URI STRING/ && target.body =~ /Total Execution Time/ && target.body =~ /Controller Execution Time/ && target.body =~ /Loading Time Base Classes/
      m << { name: 'Found 4 strings' }
    end
    m
  end
end
