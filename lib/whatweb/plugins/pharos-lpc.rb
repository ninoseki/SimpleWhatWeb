# frozen_string_literal: true

##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
WhatWeb::Plugin.define "Pharos-LPC" do
  @author = "Brendan Coles <bcoles@gmail.com>" # 2011-07-14
  @version = "0.1"
  @description = "Pharos LPC web interface - All-in-one control solution for entertainment and LED lighting installations."
  @website = "http://www.pharoscontrols.com/products/lighting_controllers/lpc"

  # Two LPC models available: LPC 1 (512 DMX channels) and LPC 2 (1024 DMX channels)

  # Datasheets for LPC and LPC X #
  # http://www.pharoscontrols.com/assets/files/datasheets/pharos_lpc_datasheet.pdf
  # http://www.pharoscontrols.com/assets/files/datasheets/pharos_lpc_x_datasheet.pdf

  # ShodanHQ results as at 2011-07-14 #
  # 5 for pharos_lpc

  # Passive #
  def passive(target)
    m = []

    # Default Title
    if /<title>Pharos LPC[^<]*<\/title>/.match?(target.body)

      # Firmware Detection
      if /<td class = "header">Firmware Version:<\/td><td colspan = "4">([^<]+)<\/td>/.match?(target.body)
        m << { firmware: target.body.scan(/<td class = "header">Firmware Version:<\/td><td colspan = "4">([^<]+)<\/td>/) }
      end

      # Module Detection
      if /<td class = "header">Expansion Modules:<\/td><td>([^<]+)<\/td>/.match?(target.body)
        m << { module: target.body.scan(/<td class = "header">Expansion Modules:<\/td><td>([^<]+)<\/td>/) }
      end

      # Model Detection
      if /<td class = "header">Product Type:<\/td><td colspan = "4">([^<]+)<\/td>/.match?(target.body)
        m << { model: target.body.scan(/<td class = "header">Product Type:<\/td><td colspan = "4">([^<]+)<\/td>/) }
      end
      if /<title>Pharos (LPC[\d]) [\d]{6}[\s]*<\/title>/.match?(target.body)
        m << { model: target.body.scan(/<title>Pharos (LPC[\d]) [\d]{6}[\s]*<\/title>/) }
      end

    end

    # Redirect Location
    m << { certainty: 75, name: "Redirect Location" } if target.headers["location"] =~ /^https?:\/\/[^\/]+\/pharos_lpc\/index\.asp$/

    # WWW-Authenticate Realm
    m << { name: "authenticate realm" } if target.headers["www-authenticate"] =~ /Digest realm="PharosLPC"/

    # Return passive matches
    m
  end
end
