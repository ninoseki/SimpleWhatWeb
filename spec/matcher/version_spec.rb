# frozen_string_literal: true

vcr_options = { cassette_name: "matcher/version", record: :new_episodes }

RSpec.describe WhatWeb::Matcher::Version, vcr: vcr_options do
  let(:versions) {
    versions = {
      "5.0.0" => [
        ["login.php", "59a69886a8c006d607369865f1b4a28c"],
        ["cors/cors.php", "855be7cf5a022c5b8b77e20a7ec42db9"]
      ],
      "5.1.2" => [
        ["privacy.php", "b56f1944c37b51f83c3c851f6f96cb0d"]
      ],
    }
  }
  subject { WhatWeb::Matcher::Version.new("Concrete5", versions, "https://www.webscantest.com/") }

  describe "#matches_format" do
    it "should return an Array" do
      expect(subject.matches_format).to eq(["5.0.0"])
    end
  end
end
