# frozen_string_literal: true

require "json"
vcr_options = { cassette_name: "cli", record: :new_episodes }
RSpec.describe WhatWeb::CLI, vcr: vcr_options do
  context "without the aggressive mode" do
    describe "#execute_plugins" do
      subject { WhatWeb::CLI.new }
      it "should return a Hash" do
        results = subject.execute_plugins "https://github.com"
        expect(results).to be_a(Hash)
      end
    end
    describe "#scan" do
      subject { WhatWeb::CLI }
      it "should output a JSON" do
        output = capture(:stdout) { subject.start %w(scan https://github.com) }
        json = JSON.parse(output)
        expect(json).to be_a(Hash)
        expect(json.dig("Title").first.dig("string")).to eq("The world’s leading software development platform · GitHub")
      end
    end
  end
  context "with the aggressive mode" do
    describe "#execute_plugins" do
      subject { WhatWeb::CLI.new }
      it "should return a Hash" do
        results = subject.execute_plugins "https://github.com"
        expect(results).to be_a(Hash)
      end
    end
    describe "#scan" do
      subject { WhatWeb::CLI }
      it "should output a JSON" do
        output = capture(:stdout) { subject.start %w(scan https://github.com) }
        json = JSON.parse(output)
        expect(json).to be_a(Hash)
      end
    end
  end

  describe "list_plugins" do
    subject { WhatWeb::CLI }
    it "should output an Array " do
      output = capture(:stdout) { subject.start %w(list_plugins) }
      json = JSON.parse(output)
      expect(json).to be_an(Array)
      expect(json.length).to eq(1750)
    end
  end
end
