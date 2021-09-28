require "spec_helper"

describe Base do
  subject { Mocks::Client.new }
  let(:mocky) { Mocks::Mocky.new }

  describe "#method_missing" do
    it "delegates calls to #get" do
      expect(subject).to receive(:get)
      subject.something
    end

    it "forwards its params to #get" do
      expect(subject).to receive(:get).with("/something", "subpath", arg: :value)
      subject.something "subpath", arg: :value
    end
  end

  describe "#cache" do
    subject { described_class.new.cache }

    it "allows getting cache life" do
      expect(subject.life).to eq 3600
    end

    it "allows getting cache dir" do
      expect(subject.dir).to eq "cache"
    end

    it "allows setting cache life" do
      subject.life = 1337
      expect(subject.life).to eq 1337
    end

    it "allows setting cache dir" do
      subject.dir = "storage"
      expect(subject.dir).to eq "storage"
    end
  end

  describe "#get" do
    context "when the client has default_query" do
      subject { Mocks::ClientWithQuery.new }

      it "does not alter input argument" do
        params = { a: 1 }
        original_params = params.clone
        result = subject.get mocky[:json], params
        expect(result['address']).to eq "22 Acacia Avenue"
        expect(params).to eq original_params
      end
    end

    context "with an html response" do
      let(:result) { subject.get mocky[:html] }

      it "returns the html string" do
        expect(result).to be_a String
        expect(result).to eq "<html>Working</html>"
      end
    end

    context "with a json response" do
      let(:result) { subject.get mocky[:json] }

      it "returns a hash" do
        expect(result).to be_a Hash
        expect(result["address"]).to eq "22 Acacia Avenue"
      end
    end

    context "with a csv response" do
      let(:result) { subject.get mocky[:csv] }

      it "returns a parsed csv array" do
        expect(result).to be_an Array
        expect(result.first).to eq ["album", "year"]
      end
    end

    context "with a 404 response" do
      let(:result) { subject.get mocky[:not_found] }

      it "returns a parsed csv array" do
        expect(result).to be_an Hash
        expect(result["still"]).to eq "parsed"
      end
    end
  end

  describe "#get!" do
    it "returns a payload object" do
      payload = subject.get! mocky[:html]
      expect(payload).to be_a Payload
    end
  end

  describe "#url" do
    it "returns the full url of the request" do
      url = subject.url "hello/world", param: "value"
      expect(url).to eq "http://www.mocky.io/v2/hello/world?param=value"
    end
  end

  describe "#save" do
    let(:filename) { "spec/tmp/out.json" }
    let(:path) { mocky[:json] }

    before do
      File.delete filename if File.exist? filename
      expect(File).not_to exist filename
    end

    it "saves to a file" do
      subject.save filename, path
      expect(File).to exist filename
    end

    it "saves the response body" do
      expected = subject.get!(path).response.body
      subject.save filename, path
      expect(File.read filename).to eq expected
    end
  end

  describe "#last_payload" do
    it "is set after a #get call" do
      subject.get mocky[:html]
      expect(subject.last_payload).to be_a Payload
    end
  end

  describe "#last_url" do
    it "is set after a #get call" do
      subject.get mocky[:html]
      expect(subject.last_url).to eq "#{subject.class.base_uri}/#{mocky[:html]}"
    end
  end

  describe "#get_csv" do
    context "with a response that contains at least one array" do
      it "returns a csv string" do
        result = subject.get_csv mocky[:array]
        expect(result).to eq fixture("array.csv")
      end
    end

    context "with a response that does not contain any array" do
      it "returns a csv string" do
        result = subject.get_csv mocky[:non_array]
        expect(result).to eq fixture("non_array.csv")
      end
    end

    context "with a non 200 response" do
      it "raises an error" do
        expect { subject.get_csv mocky[:not_found] }.to raise_error(BadResponse)
      end
    end

    context "with a non hash response" do
      it "raises an error" do
        expect { subject.get_csv mocky[:html] }.to raise_error(BadResponse)
      end
    end
  end

  describe "#save_csv" do
    let(:filename) { "spec/tmp/out.csv" }

    before do
      File.delete filename if File.exist? filename
      expect(File).not_to exist(filename)
    end

    it "saves output to a file" do
      subject.save_csv filename, mocky[:array]

      expect(File).to exist(filename)
      expect(File.read filename).to eq fixture("array.csv")
    end
  end
end
