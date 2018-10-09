# frozen_string_literal: true

require "json"

RSpec.describe WhatWeb::CLI do
  include_context "http_server"

  subject { WhatWeb::CLI }

  let(:url) { "http://#{host}:#{port}" }

  context "without the aggressive mode" do
    describe "#scan" do
      before { allow(WhatWeb).to receive(:execute_plugins).and_return({}) }
      it "should output a JSON" do
        output = capture(:stdout) { subject.start ["scan", url] }
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
        output = capture(:stdout) { subject.start ["scan", url, "--aggressive"] }
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
          capture(:stdout) { subject.start ["scan", url, "--user_agent=hoge"] }
        }.not_to raise_error
      end
    end
  end
  describe "#list_plugins" do
    it "should output an Array " do
      output = capture(:stdout) { subject.start %w(list_plugins) }
      json = JSON.parse(output)
      expect(json).to be_an(Array)
      expect(json.length).to eq(NUMBER_OF_PLUGINS)
    end
  end
end
