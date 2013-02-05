# coding: utf-8
require 'spec_helper'

describe HttpMachinegun::Client do
  let(:url) { "example.com" }
  let(:url_fully) { "http://example.com:8080/" }
  let(:port) { 8080 }
  let(:send_data) { "abcdefg" }
  before do
    @client = HttpMachinegun::Client.new(url, port, send_data)
    stub_request(:get    , url_fully).to_return(:body => 'succeed get request')
    stub_request(:post   , url_fully).to_return{|req| { :body => "succeed post request and request body #{send_data}" } }
    stub_request(:put    , url_fully).to_return{|req| { :body => "succeed put request and request body #{send_data}" } }
    stub_request(:delete , url_fully).to_return(:body => 'succeed delete request')
  end

  context "base header" do
    it { HttpMachinegun::Client::BASE_HEADERS["content-type"].should eql "text/plain" }
  end

  context "initialize" do
    it "raise error due to no args" do
      lambda{ HttpMachinegun::Client.new }.should raise_error ArgumentError
    end

    context "normal" do
      it { @client.instance_variable_get("@url").should eql url }
      it { @client.instance_variable_get("@port").should eql port }
      it { @client.instance_variable_get("@send_data").should eql send_data }
    end
  end

  context "basic_auth" do
    it "raise error if no args"  do
      expect { @client.basic_auth }.to raise_error(ArgumentError)
    end

    it "raise error if called before set http_method"  do
      expect { @client.basic_auth("hoge", "fuga") }.to raise_error(NoMethodError)
    end

    it do
      @client.http_method("get").basic_auth("hoge","fuga")
      @client.instance_variable_get("@request_body").instance_variable_get("@header")['authorization'] == Net::HTTP::Get.new('/').send(:basic_encode , "hoge","fuga")
    end
  end

  context "http_method" do

    %w(get post put delete).each do |method|
      it {@client.http_method(method).instance_variable_get("@request_body").should be_instance_of(eval("Net::HTTP::#{method.capitalize}")) }
    end

    it { expect{ @client.http_method}.to raise_error }
  end

  context "set_body" do
    subject { @client.http_method(:get).set_body.instance_variable_get("@request_body") }
    its(:body){should eql "abcdefg".to_json }
  end

  context "execute" do
    context "get request" do
      subject { @client.http_method(:get).set_body.execute }
      it { subject.code.should eql "200" }
      it { subject.body.should eql "succeed get request" }
    end

    context "post request" do
      subject { @client.http_method(:post).set_body.execute }
      it { subject.code.should eql "200" }
      it { subject.body.should eql "succeed post request and request body #{send_data}" }
    end

    context "post request" do
      subject { @client.http_method(:put).set_body.execute }
      it { subject.code.should eql "200" }
      it { subject.body.should eql "succeed put request and request body #{send_data}" }
    end

    context "delete request" do
      subject { @client.http_method(:delete).set_body.execute }
      it { subject.code.should eql "200" }
      it { subject.body.should eql "succeed delete request" }
    end
  end
end
