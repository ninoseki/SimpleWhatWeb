# frozen_string_literal: true

vcr_options = { cassette_name: "target", record: :new_episodes }
RSpec.describe WhatWeb::Target, vcr: vcr_options do
  subject { WhatWeb::Target.new "http://neverssl.com" }
  it "can get an HTTP response" do
    expect(subject.status).to eq(200)
  end

  it "should calculate a md5 value of the HTTP resposne body" do
    expect(subject.md5sum).to eq("e8bb9152091d61caa9d69fed8c4aebc6")
  end

  it "should calculate tag-pattern of the HTTP response body" do
    expect(subject.tag_pattern).to eq("html,head,title,/title,style,!--,/style,/head,body,div,div,h1,/h1,/div,/div,div,div,h2,/h2,p,/p,h2,/h2,p,a,/a,/p,h2,/h2,p,/p,p,/p,p,/p,/div,/div,/body,/html")
  end

  it "can be set an HTTP response via an argument" do
    response = HTTP.get("http://neverssl.com")
    subject.response = response
    expect(subject.status).to eq(200)
  end
end
