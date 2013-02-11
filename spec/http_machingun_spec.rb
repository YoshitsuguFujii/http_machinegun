# coding: utf-8
require 'spec_helper'

describe HttpMachinegun do
  let(:url) { "http://example.com" }
  let(:url_fully) { "http://example.com:80/" }
  let(:port) { 3000 }
  let(:send_data) { "abcdefg" }

  let(:default_port) { 80 }
  let(:default_send_data) { "" }

  before do
    @client = HttpMachinegun::Client.new(url, port, send_data)
    stub_request(:get    , url_fully).to_return(:body => 'succeed get request')
    stub_request(:post   , url_fully).to_return{|req| { :body => "succeed post request and request body #{send_data}" } }
    stub_request(:put    , url_fully).to_return{|req| { :body => "succeed put request and request body #{send_data}" } }
    stub_request(:delete , url_fully).to_return(:body => 'succeed delete request')
    stub_request(:get    , url + ":" + port.to_s + "/").to_return(:body => 'succeed get request')
  end

  context "argument" do
    context "url" do
      subject { HttpMachinegun::Machinegun }
      it "is empty" do
        output = capture(:stdout) {
          subject.start(["fire"])
        }
        output.should_not include("http_status_code:200")
      end

      it "only" do
        output = capture(:stdout) {
          subject.start(["fire","--url", url])
        }
        output.should include("http_status_code:200")
      end

      context "parameter is correct" do
        subject{ HttpMachinegun::Machinegun.start(["fire","--url", url]) }

        it { subject.first.instance_variable_get("@url").to_s.should eq url }
        it { subject.first.instance_variable_get("@port").should eq default_port }
        it { subject.first.instance_variable_get("@request_body").should be_instance_of(Net::HTTP::Get) }
        it { subject.first.instance_variable_get("@send_data").should be_instance_of(HttpMachinegun::Data) }
        it { subject.first.instance_variable_get("@send_data").to_s.should eq default_send_data }
        its(:length){ should eq 1}
      end
    end

    context "port" do
      subject { HttpMachinegun::Machinegun }
      it "is empty" do
        output = capture(:stdout) {
          subject.start(["fire","--url", url])
        }
        output.should include("http_status_code:200")
      end

      it "only" do
        output = capture(:stdout) {
          subject.start(["fire","--port", port])
        }
        output.should_not include("http_status_code:200")
      end

      context "parameter is correct" do
        subject{ HttpMachinegun::Machinegun.start(["fire","--url", url, "--port", port]) }

        it { subject.first.instance_variable_get("@url").to_s.should eq url }
        it { subject.first.instance_variable_get("@port").should eq port }
        it { subject.first.instance_variable_get("@request_body").should be_instance_of(Net::HTTP::Get) }
        it { subject.first.instance_variable_get("@send_data").should be_instance_of(HttpMachinegun::Data) }
        it { subject.first.instance_variable_get("@send_data").to_s.should eq default_send_data }
        its(:length){ should eq 1}
      end
    end

    context "data_or_file_path" do
      subject { HttpMachinegun::Machinegun }
      it "is empty" do
        output = capture(:stdout) {
          subject.start(["fire","--url", url])
        }
        output.should include("http_status_code:200")
      end

      it "only" do
        output = capture(:stdout) {
          subject.start(["fire","--data_or_file_path", send_data])
        }
        output.should_not include("http_status_code:200")
      end

      context "parameter is correct" do
        subject{ HttpMachinegun::Machinegun.start(["fire","--url", url, "--port", port, "--data_or_file_path", send_data]) }

        it { subject.first.instance_variable_get("@url").to_s.should eq url }
        it { subject.first.instance_variable_get("@port").should eq port }
        it { subject.first.instance_variable_get("@request_body").should be_instance_of(Net::HTTP::Get) }
        it { subject.first.instance_variable_get("@send_data").should be_instance_of(HttpMachinegun::Data) }
        it { subject.first.instance_variable_get("@send_data").to_s.should eq send_data }
        its(:length){ should eq 1}
      end
    end

    context "method" do
      subject { HttpMachinegun::Machinegun }
      it "is empty" do
        output = capture(:stdout) {
          subject.start(["fire","--url", url])
        }
        output.should include("http_status_code:200")
      end

      it "only" do
        output = capture(:stdout) {
          subject.start(["fire","--method", :get])
        }
        output.should_not include("http_status_code:200")
      end

      context "parameter is correct" do
        context "get session" do
          subject{ HttpMachinegun::Machinegun.start(["fire","--url", url, "--port", port, "--data_or_file_path", send_data, "--method", :get]) }

          it { subject.first.instance_variable_get("@url").to_s.should eq url }
          it { subject.first.instance_variable_get("@port").should eq port }
          it { subject.first.instance_variable_get("@request_body").should be_instance_of(Net::HTTP::Get) }
          it { subject.first.instance_variable_get("@send_data").should be_instance_of(HttpMachinegun::Data) }
          it { subject.first.instance_variable_get("@send_data").to_s.should eq send_data }
          its(:length){ should eq 1}
        end

        context "post session" do
          subject{ HttpMachinegun::Machinegun.start(["fire","--url", url, "--data_or_file_path", send_data, "--method", :post]) }

          it { subject.first.instance_variable_get("@url").to_s.should eq url }
          it { subject.first.instance_variable_get("@port").should eq default_port }
          it { subject.first.instance_variable_get("@request_body").should be_instance_of(Net::HTTP::Post) }
          it { subject.first.instance_variable_get("@send_data").should be_instance_of(HttpMachinegun::Data) }
          it { subject.first.instance_variable_get("@send_data").to_s.should eq send_data }
          its(:length){ should eq 1}
        end

        context "put session" do
          subject{ HttpMachinegun::Machinegun.start(["fire","--url", url, "--data_or_file_path", send_data, "--method", :put]) }

          it { subject.first.instance_variable_get("@url").to_s.should eq url }
          it { subject.first.instance_variable_get("@port").should eq default_port }
          it { subject.first.instance_variable_get("@request_body").should be_instance_of(Net::HTTP::Put) }
          it { subject.first.instance_variable_get("@send_data").should be_instance_of(HttpMachinegun::Data) }
          it { subject.first.instance_variable_get("@send_data").to_s.should eq send_data }
          its(:length){ should eq 1}
        end

        context "delete session" do
          subject{ HttpMachinegun::Machinegun.start(["fire","--url", url, "--data_or_file_path", send_data, "--method", :delete]) }

          it { subject.first.instance_variable_get("@url").to_s.should eq url }
          it { subject.first.instance_variable_get("@port").should eq default_port }
          it { subject.first.instance_variable_get("@request_body").should be_instance_of(Net::HTTP::Delete) }
          it { subject.first.instance_variable_get("@send_data").should be_instance_of(HttpMachinegun::Data) }
          it { subject.first.instance_variable_get("@send_data").to_s.should eq send_data }
          its(:length){ should eq 1}
        end
      end
    end

    context "thread_number" do
      subject { HttpMachinegun::Machinegun }
      it "is empty" do
        output = capture(:stdout) {
          subject.start(["fire","--url", url])
        }
        output.should include("http_status_code:200")
      end

      it "only" do
        output = capture(:stdout) {
          subject.start(["fire","--thread_number", 1])
        }
        output.should_not include("http_status_code:200")
      end

      context "parameter is correct" do
        subject{ HttpMachinegun::Machinegun.start(["fire","--url", url, "--thread_number", 10, "--data_or_file_path", send_data]) }

        it { subject.first.instance_variable_get("@url").to_s.should eq url }
        it { subject.first.instance_variable_get("@port").should eq default_port }
        it { subject.first.instance_variable_get("@request_body").should be_instance_of(Net::HTTP::Get) }
        it { subject.first.instance_variable_get("@send_data").should be_instance_of(HttpMachinegun::Data) }
        it { subject.first.instance_variable_get("@send_data").to_s.should eq send_data }
        its(:length){ should eq 10}
      end
    end
  end
end
