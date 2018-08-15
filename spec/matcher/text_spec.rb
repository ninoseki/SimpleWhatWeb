# frozen_string_literal: true

vcr_options = { cassette_name: "matcher/text", record: :new_episodes }

RSpec.describe WhatWeb::Matcher::Text, vcr: vcr_options do
  let(:target) { WhatWeb::Target.new "http://150.60.46.194/" }

  context "when deals with a non-empty text" do
    let(:match) { { text: '<!-- /all in one seo pack -->' } }
    subject { WhatWeb::Matcher::Text.new(target, match) }
    describe "#match?" do
      it "should return true" do
        expect(subject.match?).to be(true)
      end
    end
  end
  context "when deals with an empty text" do
    let(:match) { { name: "X-AwCache-FollowUp Header", text: "", search: "headers[x-awcache-followup]" } }
    subject { WhatWeb::Matcher::Text.new(target, match) }
    describe "#match?" do
      it "should return false" do
        expect(subject.match?).to be(false)
      end
    end
  end
end
