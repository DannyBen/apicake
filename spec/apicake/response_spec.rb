require 'spec_helper'
require 'ostruct'

describe Response do
  let(:mock) { Mocks::HTTPartyResponse.new } 
  let(:subject) { Response.new mock }

  describe '#new' do
    it "creates an object from HTTParty response" do
      expected = { request: :request, response: :response, headers: :headers, parsed_response: :parsed_response }
      expect(subject.to_h).to eq expected
    end
  end

  describe '#to_s' do
    it "returns the parsed response" do
      expect(subject.to_s).to eq subject.parsed_response.to_s
    end
  end
end
