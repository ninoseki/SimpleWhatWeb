# frozen_string_literal: true

vcr_options = { cassette_name: "matcher/url", record: :new_episodes }

RSpec.describe WhatWeb::Matcher::URL, vcr: vcr_options do
  let(:target) { WhatWeb::Target.new "https://github.com/urbanadventurer/WhatWeb/blob/master/lib/plugins.rb" }
  let(:match) { { url: "/lib/plugins.rb" } }
  subject { WhatWeb::Matcher::URL.new(target, match) }

  describe "#match?" do
    it "should return true" do
      expect(subject.match?).to be(true)
    end
  end
end
