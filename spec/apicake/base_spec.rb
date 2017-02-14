require 'spec_helper'

describe Base do
  let(:subject) { described_class.new }
  let(:mocky) { Mocks::Mocky.new }

  describe "#method_missing" do
    it "delegates calls to #get" do
      expect(subject).to receive(:get)
      subject.something
    end

    it "forwards its params to #get" do
      expect(subject).to receive(:get).with('/something', 'subpath', arg: :value)
      subject.something 'subpath', arg: :value
    end
  end

  describe "#cache" do
    let(:subject) { described_class.new.cache }

    it "allows getting cache life" do
      expect(subject.life).to eq 3600
    end
    
    it "allows getting cache dir" do
      expect(subject.dir).to eq 'cache'
    end

    it "allows setting cache life" do
      subject.life = 1337
      expect(subject.life).to eq 1337
    end

    it "allows setting cache dir" do
      subject.dir = 'storage'
      expect(subject.dir).to eq 'storage'
    end
  end

  describe "#get" do
    let(:subject) { Mocks::Client.new }

    context "with an html response" do
      let(:result) { subject.get mocky[:html] }

      it "returns the html string" do
        expect(result).to be_a String
        expect(result).to eq '<html>Working</html>'
      end
    end

    context "with a json response" do
      let(:result) { subject.get mocky[:json] }
      
      it "returns a hash" do
        expect(result).to be_a Hash
        expect(result['address']).to eq '22 Acacia Avenue'
      end
    end

    context "with a csv response" do
      let(:result) { subject.get mocky[:csv] }
      
      it "returns a parsed csv array" do
        expect(result).to be_an Array
        expect(result.first).to eq ['album', 'year']
      end
    end
  end
end
