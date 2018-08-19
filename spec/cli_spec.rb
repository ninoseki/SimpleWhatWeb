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
end
