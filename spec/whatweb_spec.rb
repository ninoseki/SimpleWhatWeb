# frozen_string_literal: true

RSpec.describe WhatWeb do
  include_context "http_server"

  let(:url) { "http://#{host}:#{port}" }

  subject { WhatWeb }

  it "has a version number" do
    expect(subject::VERSION).not_to be nil
  end

  describe ".execute_plugins" do
    context "without the aggressive mode" do
      it "should return a Hash" do
        results = subject.execute_plugins url
        expect(results).to be_a(Hash)
        expect(results.dig("Title").first.dig(:string)).to eq("Not Found")
      end
    end
    context "with the aggressive mode" do
      it "should return a Hash" do
        allow_any_instance_of(WhatWeb::Plugin).to receive(:randstr).and_return("fqeewoohxevinxslnplhjbymmeplmkwl")
        results = subject.execute_plugins(url, is_aggressive: true)
        expect(results).to be_a(Hash)
      end
    end
  end

  describe ".plugin_names" do
    it "should return an Array " do
      array = subject.plugin_names
      expect(array).to be_an(Array)
      expect(array.length).to eq(NUMBER_OF_PLUGINS)
    end
  end
end
