# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.3 # 2011-01-21 #
# Updated credential extraction
# Added SHA1 hashes for common admin passwords
# Renamed plugin from "Credentials" to "htpasswd"
##
# Version 0.2
# Now requires htpasswd in the URL path to reduce false positives
#
##
WhatWeb::Plugin.define "htpasswd" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-10-23
  @version = "0.3"
  @description = ".htpasswd is a flat-file used to store usernames and password for basic authentication of Apache HTTP Server. This plugin attempts to retrievs credentials from .htpasswd files in user:pass format. - More info: http://en.wikipedia.org/wiki/Htpasswd"

  # Google Results as at 2011-01-21 #
  # 110 results for inurl:htpasswd ext:txt
  # 181 results for filetype:htpasswd htpasswd
  # 179 results for filetype:htpasswd inurl:htpasswd
  # 35 results for htpasswd filetype:bak
  # 2 results for ext:htpasswd1
  # 2 results for inurl:"htpasswd" ext:bak

  # Dorks #
  @dorks = [
    'inurl:htpasswd ext:txt',
    'filetype:htpasswd htpasswd',
    'filetype:htpasswd inurl:htpasswd'
  ]

  # Passive #
  # Extract credentials in user{2-255}:pass{1-80} format
  # Accepts : sha1, md4, md5, plaintext
  # The code is pretty ugly, but fast. Formatted for 80x24. Improvements welcomed.
  def passive(target)
    m = []

    # Check if the current file is a .htpasswd file
    if target.uri.path =~ /htpasswd/i && target.body =~ /^([0-9a-z\-_]{2,255}:[^\r^\n^\s^:]{1,80})[\r\n\s:]*/i

      # Loop through the results
      target.body.scan(/^([0-9a-z\-_]{2,255}:[^\r^\n^\s^:]{1,80})[\r\n\s:]*/i).each do |line|
        # Compare hash to a few common passwords if the user is "admin"
        m << if /^admin:\$apr1\$/.match?(line.to_s)

               # Common passwords # SHA1
               if line.to_s == "admin:$apr1$Ev0Cp...$6R55smBmW.t.uDr01ao5Q."
                 { account: "admin:admin" }
               elsif line.to_s == "admin:$apr1$XNQFp...$HCpZx9aTaQOD1vVFeGXUF1"
                 { account: "admin:password" }
               elsif line.to_s == "admin:$apr1$94APp...$Vs/UEEdcnanhzIvFweeVd."
                 { account: "admin:password1" }
               elsif line.to_s == "admin:$apr1$WqFQp...$xgPFU8Ao92A7eYg8J2cYx/"
                 { account: "admin:Password" }
               elsif line.to_s == "admin:$apr1$3fdSp...$qq4wV9G75szLU/hJsGHYQ1"
                 { account: "admin:12345" }
               elsif line.to_s == "admin:$apr1$b5XTp...$BcezBLeXvd7QT5Rlw.8Ki1"
                 { account: "admin:123456" }
               elsif line.to_s == "admin:$apr1$WRMUp...$THfv/Ixp9HKpKH34dtzO3."
                 { account: "admin:qwerty" }
               elsif line.to_s == "admin:$apr1$cT/Vp...$aOLWPBRTibzuNEhVpiw7V1"
                 { account: "admin:abc123" }
               elsif line.to_s == "admin:$apr1$5PaVp...$gYaTwDl0yviTysvEY4REn0"
                 { account: "admin:letmein" }

               # Display hash if unknown
               else
                 { account: line.to_s }
                    end

             # Display hash if user is not "admin"
             else
               { account: line.to_s }
             end
      end

    end

    m
  end
end
