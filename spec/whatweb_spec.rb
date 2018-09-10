# frozen_string_literal: true

vcr_options = { cassette_name: "whatweb", record: :new_episodes }
RSpec.describe WhatWeb, vcr: vcr_options do
  subject { WhatWeb }
  it "has a version number" do
    expect(subject::VERSION).not_to be nil
  end
  context "without the aggressive mode" do
    describe "#execute_plugins" do
      it "should return a Hash" do
        results = subject.execute_plugins "https://www.webscantest.com"
        expect(results).to be_a(Hash)
        expect(results.dig("Title").first.dig(:string)).to eq("Test Site")
      end
    end
  end
  context "with the aggressive mode" do
    describe "#execute_plugins" do
      it "should return a Hash" do
        allow_any_instance_of(WhatWeb::Plugin).to receive(:randstr).and_return("fqeewoohxevinxslnplhjbymmeplmkwl")
        results = subject.execute_plugins("https://www.webscantest.com", is_aggressive: true)
        expect(results).to be_a(Hash)
      end
    end
  end
  describe "#plugin_names" do
    it "should return an Array " do
      array = subject.plugin_names
      expect(array).to be_an(Array)
      expect(array.length).to eq(1750)
    end
  end
end
