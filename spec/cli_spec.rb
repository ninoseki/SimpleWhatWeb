# frozen_string_literal: true

require "json"

RSpec.describe WhatWeb::CLI do
  subject { WhatWeb::CLI }
  context "without the aggressive mode" do
    describe "#scan" do
      before { allow(WhatWeb).to receive(:execute_plugins).and_return({}) }
      it "should output a JSON" do
        output = capture(:stdout) { subject.start %w(scan https://www.webscantest.com) }
        json = JSON.parse(output)
        expect(json).to be_a(Hash)
      end
    end
  end
  context "with the aggressive mode" do
    describe "#scan" do
      before { allow(WhatWeb).to receive(:execute_plugins).and_return({}) }
      it "should output a JSON" do
        allow_any_instance_of(WhatWeb::Plugin).to receive(:randstr).and_return("fqeewoohxevinxslnplhjbymmeplmkwl")
        output = capture(:stdout) { subject.start %w(scan https://www.webscantest.com --aggressive) }
        json = JSON.parse(output)
        expect(json).to be_a(Hash)
      end
    end
  end
  context "with a custom user_agent" do
    describe "#scan" do
      before { allow(WhatWeb).to receive(:execute_plugins).and_return({}) }
      it "should not raise any error" do
        ## I don't know how to test HTTP request header value...
        expect {
          capture(:stdout) { subject.start %w(scan https://www.webscantest.com --user_agent=hoge) }
        }.not_to raise_error
      end
    end
  end
  describe "#list_plugins" do
    it "should output an Array " do
      output = capture(:stdout) { subject.start %w(list_plugins) }
      json = JSON.parse(output)
      expect(json).to be_an(Array)
      expect(json.length).to eq(1750)
    end
  end
end
