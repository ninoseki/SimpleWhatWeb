# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.2 #
# Updated regex
##
WhatWeb::Plugin.define "Microsoft-Office-XML" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-10-14
  @version = "0.2"
  @description = "This module detects instances of Microsoft Office documents saved as HTML and attempts to extract the user name, company name and office version."
  @website = "http://en.wikipedia.org/wiki/Microsoft_Office_XML_formats"

  # About 123,000 results for <o:DocumentProperties> <o:Template> @ 2010-10-14

  # Extract version, usernames and company
  def passive(target)
    m = []

    # Excel
    if target.body =~ /<DocumentProperties xmlns="urn:schemas-microsoft-com:office:[excel|office]?">/ || target.body =~ /<?mso-application progid="Excel.Sheet"?>/

      # Get version
      if /<Version>([^<]+)<\/Version>/.match?(target.body)
        version = target.body.scan(/<Version>([^<]+)<\/Version>/)
        m << { version: "Excel " + version }
      end

      # Get company
      if /<Company>([^<]+)<\/Company>/.match?(target.body)
        accounts = target.body.scan(/<Company>([^<]+)<\/Company>/)[0][0]
        m << { account: "Company:" + accounts }
      end

      # Get usernames
      if /<Author>([^<]+)<\/Author>/.match?(target.body)
        accounts = target.body.scan(/<Author>([^<]+)<\/Author>/)[0][0]
        m << { account: accounts }
      end

      if /<LastAuthor>([^<]+)<\/LastAuthor>/.match?(target.body)
        accounts = target.body.scan(/<LastAuthor>([^<]+)<\/LastAuthor>/)[0][0]
        m << { account: accounts }
      end

    end

    # Word
    if target.body =~ /<o:DocumentProperties>/ || target.body =~ /<?mso-application progid="Word.Document"?>/

      # Get version
      if /<o:Version>([^<]+)<\/o:Version>/.match?(target.body)
        version = target.body.scan(/<o:Version>([^<]+)<\/o:Version>/)[0][0]
        m << { version: "Word " + version }
      end

      # Get company
      if /<o:Company>([^<]+)<\/o:Company>/.match?(target.body)
        accounts = target.body.scan(/<o:Company>([^<]+)<\/o:Company>/)[0][0]
        m << { account: "Company:" + accounts }
      end

      # Get usernames
      if /<o:Author>([^<]+)<\/o:Author>/.match?(target.body)
        accounts = target.body.scan(/<o:Author>([^<]+)<\/o:Author>/)[0][0]
        m << { account: accounts }
      end

      if /<o:LastAuthor>([^<]+)<\/o:LastAuthor>/.match?(target.body)
        accounts = target.body.scan(/<o:LastAuthor>([^<]+)<\/o:LastAuthor>/)[0][0]
        m << { account: accounts }
      end

    end

    # Core document properties
    if /<cp:coreProperties/.match?(target.body)

      # Get usernames
      if /<dc:creator>([^<]+)<\/creator>/.match?(target.body)
        accounts = target.body.scan(/<dc:creator>([^<]+)<\/creator>/)[0][0]
        m << { account: accounts }
      end

      if /<dc:lastModifiedBy>([^<]+)<\/creator>/.match?(target.body)
        accounts = target.body.scan(/<dc:lastModifiedBy>([^<]+)<\/creator>/)[0][0]
        m << { account: accounts }
      end

      # Get company
      if /<Company>([^<]+)<\/Company>/.match?(target.body)
        accounts = target.body.scan(/<Company>([^<]+)<\/Company>/)[0][0]
        m << { account: "Company:" + accounts }
      end

      # Get version
      if /<AppVersion>([^<]+)<\/AppVersion>/.match?(target.body)
        version = target.body.scan(/<AppVersion>([^<]+)<\/AppVersion>/)[0][0]
        m << { version: version }
      end

    end

    m
  end
end
