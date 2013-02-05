# coding: utf-8
require 'spec_helper'

describe HttpMachinegun::Data do

  context "when argument is string" do
    it{ HttpMachinegun::Data.new("abcdef").to_s.should eql "abcdef" }
  end

  context "when argument is file path" do
    it do
      file_path = "#{File.dirname(__FILE__)}/resources/data_fixture.txt"
      HttpMachinegun::Data.new(file_path).to_s.should eql File.read(file_path)
    end
  end

end
