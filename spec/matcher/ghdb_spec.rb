# frozen_string_literal: true

vcr_options = { cassette_name: "matcher/ghdb", record: :new_episodes }

RSpec.describe WhatWeb::Matcher::GHDB, vcr: vcr_options do
  context "DockuWiki website" do
    let(:target) { WhatWeb::Target.new "https://docs.worldnettps.com/doku.php?id=developer:integration_docs:sandbox_testing" }
    let(:match) { { ghdb: '"powered by DokuWiki" inurl:doku.php filetype:php' } }
    subject { WhatWeb::Matcher::GHDB.new(target, match) }

    describe "#match?" do
      it "should return true" do
        expect(subject.match?).to be(true)
      end
    end
    describe "#match_intitle?" do
      it "should return false" do
        expect(subject.match_intitle?).to be(false)
      end
    end
    describe "#match_filetype?" do
      it "should return true" do
        expect(subject.match_filetype?).to be(true)
      end
    end
    describe "#match_inurl?" do
      it "should return true" do
        expect(subject.match_inurl?).to be(true)
      end
    end
    describe "#match_others?" do
      it "should return true" do
        expect(subject.match_others?).to be(true)
      end
    end
    describe "#query_for_others" do
      it "should return a cleaned query" do
        expect(subject.query_for_others).to eq('"powered by DokuWiki"  ')
      end
    end
  end
  context "github.com" do
    let(:target) { WhatWeb::Target.new "https://github.com" }
    let(:match) { { ghdb: '"powered by 360 Web Manager"', certainty: 75 } }
    subject { WhatWeb::Matcher::GHDB.new(target, match) }

    describe "#match?" do
      it "should return true" do
        expect(subject.match?).to be(false)
      end
    end
    describe "#match_intitle?" do
      it "should return false" do
        expect(subject.match_intitle?).to be(false)
      end
    end
    describe "#match_filetype?" do
      it "should return true" do
        expect(subject.match_filetype?).to be(false)
      end
    end
    describe "#match_inurl?" do
      it "should return true" do
        expect(subject.match_inurl?).to be(false)
      end
    end
    describe "#match_others?" do
      it "should return true" do
        expect(subject.match_others?).to be(false)
      end
    end
    describe "#query_for_others" do
      it "should return a cleaned query" do
        expect(subject.query_for_others).to eq('"powered by 360 Web Manager"')
      end
    end
  end
end
