# frozen_string_literal: true

RSpec.describe WhatWeb::PluginManager do
  include_context "http_server"

  let(:url) { "http://#{host}:#{port}" }
  let(:target) { WhatWeb::Target.new url }

  subject { WhatWeb::PluginManager.instance }

  before(:each) { subject.load_plugins }

  describe "#load_plugins" do
    it "should load all plugins" do
      expect(subject.registered_plugins.keys.length).to eq(NUMBER_OF_PLUGINS)
    end
    describe "#passive" do
      it "should not raise any error" do
        subject.registered_plugins.each do |_, plugin|
          expect {
            plugin.passive target
          }.to_not raise_error
        end
      end
    end
    describe "#aggressive" do
      it "should not raise any error" do
        allow_any_instance_of(WhatWeb::Plugin).to receive(:randstr).and_return("fqeewoohxevinxslnplhjbymmeplmkwl")
        subject.registered_plugins.each do |_, plugin|
          expect {
            plugin.aggressive target
          }.to_not raise_error
        end
      end
    end
  end
end
