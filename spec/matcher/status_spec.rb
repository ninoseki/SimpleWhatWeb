# frozen_string_literal: true

vcr_options = { cassette_name: "matcher/status", record: :new_episodes }

RSpec.describe WhatWeb::Matcher::Status, vcr: vcr_options do
  let(:target) { WhatWeb::Target.new "http://neverssl.com" }
  let(:match) { { status: 200 } }
  subject { WhatWeb::Matcher::Status.new(target, match) }

  describe "#match?" do
    it "should return true" do
      expect(subject.match?).to be(true)
    end
  end
end
