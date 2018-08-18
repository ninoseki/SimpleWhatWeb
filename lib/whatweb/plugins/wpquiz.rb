# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "wpQuiz" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2010-08-21
  @version = "0.1"
  @description = "wpQuiz is a fully-featured quiz script."
  @website = "http://www.wireplastik.com/"

  # 42 results for "powered by wpQuiz" intitle:"Register - wpQuiz" inurl:register.php @ 2010-08-21

  @matches = [

    { regexp: /<title>[^>]*>> [Register|Login]+ - wp[q|Q]+uiz<\/title>/ },
    { text: "<div class='small' style='text-align: center;'>Powered by wpQuiz</div>
    " },

  ]

  def passive(target)
    m = []

    if /<span class='big'><b><img src='img\/mainlogo.png' alt='[^\']+' \/> [\d\.a-z]+<\/b><\/span>/.match?(target.body)
      version = target.body.scan(/<span class='big'><b><img src='img\/mainlogo.png' alt='[^\']+' \/> ([\d\.a-z]+)<\/b><\/span>/)[0][0]
      m << { version: version }
    end

    if /<img src="http:\/\/www.wireplastik.com\/wplog.php\?al=/.match?(target.body)
      if /[\d\.a-z]+ \| [0-9]+ Template/.match?(target.body)
        version = target.body.scan(/([\d\.a-z]+) \| [0-9]+ Template/)[0][0]
        m << { version: version }
      end
    end

    m
  end
end
