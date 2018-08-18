# frozen_string_literal: true

vcr_options = { cassette_name: "plugin", record: :new_episodes }
RSpec.describe WhatWeb::Plugin, vcr: vcr_options do
  before(:each) do
    @plugin = WhatWeb::Plugin.define "Open-Graph-Protocol" do
      @author = "Caleb Anderson"
      @version = "0.3"
      @description = "The Open Graph protocol enables you to integrate your Web pages into the social graph. It is currently designed for Web pages representing profiles of real-world things . things like movies, sports teams, celebrities, and restaurants. Including Open Graph tags on your Web page, makes your page equivalent to a Facebook Page."
      # Matches #
      @matches = [
        # Meta tag # Match og:title
        { regexp: /<meta[^>]+property="og:title"[^>]*>/i },
        # Get type # og:type
        { version: /<meta[^>]+property="og:type"[^>]+content="([^"^>]+)"/ },
        # Get user IDs # fb:admins
        { account: /<meta[^>]+property="fb:admins"[^>]+content="([^"^>]+)"/ },
        # Get app IDs # fb:app_id
        { module: /<meta[^>]+property="fb:app_id"[^>]+content="([^"^>]+)"/ },
      ]
    end
  end
  describe "#self.define" do
    it "should load variables via a given block" do
      expect(@plugin.author).to eq("Caleb Anderson")
      expect(@plugin.version).to eq("0.3")
      expect(@plugin.description).to eq("The Open Graph protocol enables you to integrate your Web pages into the social graph. It is currently designed for Web pages representing profiles of real-world things . things like movies, sports teams, celebrities, and restaurants. Including Open Graph tags on your Web page, makes your page equivalent to a Facebook Page.")
      expect(@plugin.matches).to be_an(Array)
      expect(@plugin.matches.length).to be(4)
    end
  end
  describe "#execute" do
    it "should return an Array" do
      target = WhatWeb::Target.new "https://github.com"
      results = @plugin.execute target
      expect(results).to be_an(Array)
    end
  end
end
