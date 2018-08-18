# frozen_string_literal: true

vcr_options = { cassette_name: "matcher/md5", record: :new_episodes }

RSpec.describe WhatWeb::Matcher::Text, vcr: vcr_options do
  let(:target) { WhatWeb::Target.new "https://demo.phpmyadmin.net/favicon.ico" }
  let(:match) { { md5: '531b63a51234bb06c9d77f219eb25553' } }
  subject { WhatWeb::Matcher::MD5.new(target, match) }

  describe "#match?" do
    it "should return true" do
      expect(subject.match?).to be(true)
    end
  end
end
