require 'spec_helper'

describe Base do
  let(:subject) { Base.new }

  it "delegates missing methods to #get"

  describe "#cache" do
    it "allows getting cache life"
    it "allows getting cache dir"
    it "allows setting cache life"
    it "allows setting cache dir"
  end

  describe "#get" do
    it "calls httparty get"
    it "returns a response object"
  end
end
