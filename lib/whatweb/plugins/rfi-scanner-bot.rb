# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "RFI-Scanner-Bot" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-10-15
  @version = "0.1"
  @description = "This plugin idenitfies instances of Remote File Include Scanner bots (aka feelscanz.pl, gmjk.pl, FeeLCoMz.pl, rfi.pl) and extracts the command and control servers, channels and passwords."

  # 57 results for "##[ RUTIN SEARCH ENGINE ]##" "my @servers" "#!/usr/bin/perl" @ 2010-10-15
  # 21 results for "perl feelscanz.pl <chan w/o #> <server> <port>" @ 2010-10-15
  # 57 results for "my @servers" "#!/usr/bin/perl" +chan +nick ext:txt

  # Extract bot config
  def passive(target)
    m = []

    if target.body =~ /^## + RFI Scan & Exploit \(Exploit per engine\)        ##/ || target.body =~ /^######################################################/ || target.body =~ /^##   perl feelscanz.pl <chan w\/o #> <server> <port> ##/ || target.body =~ /##\[ RUTIN SEARCH ENGINE \]##/ || target.body =~ /^## + Fixed cryptz command \(v4.5\)/ && target.body =~ /^#!\/usr\/bin\/perl/

      # Servers
      if /^my @servers[\s]*=[\s]*\(([^\)]+)/.match?(target.body)
        modules = target.body.scan(/^my @servers[\s]*=[\s]*\(([^\)]+)/)
        m << { module: modules }
      end

      # Port
      if /^my @ports[\s]*=[\s]*\(([^\)]+)/.match?(target.body)
        modules = target.body.scan(/^my @ports[\s]*=[\s]*\(([^\)]+)/)
        m << { module: modules }
      elsif /^[\s]+port[\s]*=>[\s]*([^\r^\n]+)/.match?(target.body)
        modules = target.body.scan(/^[\s]+port[\s]*=>[\s]*([^\r^\n]+)/)
        m << { module: modules }
      end

      # Channels
      if /^[\s]+chan[\s]*=>[\s]*([^\r^\n]+)/.match?(target.body)
        modules = target.body.scan(/^[\s]+chan[\s]*=>[\s]*([^\r^\n]+)/)
        m << { module: modules }
      end

      # Accounts
      if /^[\s]*pass[\s]*=>[\s]*([^,^\r^\n]+)/.match?(target.body)
        accounts = target.body.scan(/^[\s]*pass[\s]*=>[\s]*([^,^\r^\n]+)/)
        m << { account: accounts }
      end

      # Version
      if /^my \$versi[\s]*=[\s]*"([^\"]+)/.match?(target.body)
        version = target.body.scan(/^my \$versi[\s]*=[\s]*"([^\"]+)/)
        m << { version: version }
      end

    end

    m
  end
end
