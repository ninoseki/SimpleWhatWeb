# frozen_string_literal: true

vcr_options = { cassette_name: "plugin_manager", record: :new_episodes }
RSpec.describe WhatWeb::PluginManager, vcr: vcr_options do
  let(:target) { WhatWeb::Target.new "https://www.webscantest.com/" }
  subject { WhatWeb::PluginManager.instance }

  before(:each) { subject.load_plugins }

  describe "#load_plugins" do
    it "should load all plugins" do
      expect(subject.registered_plugins.keys.length).to eq(1750)
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
        subject.registered_plugins.each do |_, plugin|
          expect {
            plugin.aggressive target
          }.to_not raise_error
        end
      end
    end
  end
end
