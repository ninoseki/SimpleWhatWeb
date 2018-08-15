# frozen_string_literal: true

vcr_options = { cassette_name: "matcher/common", record: :new_episodes }

RSpec.describe WhatWeb::Matcher::Common, vcr: vcr_options do
  let(:target) { WhatWeb::Target.new "https://github.com" }
  let(:match) { { module: /<meta[^>]+property="fb:app_id"[^>]+content="([^"^>]+)"/ } }
  subject { WhatWeb::Matcher::Common.new(target, match) }

  describe "#match?" do
    it "should return true" do
      expect(subject.match?).to be(true)
    end
  end
  describe "#match_results" do
    it "should return an array" do
      expect(subject.match_results).to eq(["1401488693436528"])
    end
  end
end
