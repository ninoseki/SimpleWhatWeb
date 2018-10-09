# frozen_string_literal: true

require "glint"
require "webrick"

def server
  server = Glint::Server.new do |port|
    http = WEBrick::HTTPServer.new(
      BindAddress: "0.0.0.0",
      Port: port,
      Logger: WEBrick::Log.new(File.open(File::NULL, "w")),
      AccessLog: []
    )
    trap(:INT) { http.shutdown }
    trap(:TERM) { http.shutdown }
    http.start
  end

  Glint::Server.info[:http_server] = {
    host: "0.0.0.0",
    port: server.port
  }

  server
end

RSpec.shared_context "http_server" do
  before(:all) {
    @server = server
    @server.start
  }
  after(:all) { @server.stop }

  let(:host) { "0.0.0.0" }
  let(:port) { @server.port }
end
