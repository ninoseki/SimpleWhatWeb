# frozen_string_literal: true

vcr_options = { cassette_name: "matcher/tag_pattern", record: :new_episodes }

RSpec.describe WhatWeb::Matcher::TagPattern, vcr: vcr_options do
  let(:target) { WhatWeb::Target.new "http://neverssl.com" }
  let(:match) { { tag_pattern: "html,head,title,/title,style,!--,/style,/head,body,div,div,h1,/h1,/div,/div,div,div,h2,/h2,p,/p,h2,/h2,p,a,/a,/p,h2,/h2,p,/p,p,/p,p,/p,/div,/div,/body,/html" } }
  subject { WhatWeb::Matcher::TagPattern.new(target, match) }

  describe "#match?" do
    it "should return true" do
      expect(subject.match?).to be(true)
    end
  end
end
