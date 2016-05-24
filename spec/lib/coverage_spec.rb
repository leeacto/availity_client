require 'spec_helper'
require 'availity_client/coverage'
require 'support/common_stubs'

describe Coverage do

  before do
    ENV['AVAILITY_API_KEY'] = 'fakeApiKeyHere'
  end

  describe ".get" do
    context "without ID param" do
      it "makes proper HTTP request" do
        stub_coverage_index_response
        response = Coverage.get

        expect(response[:status]).to eq 200
        expect(response[:body]).not_to be_nil
      end

      it "makes proper HTTP request given parameters" do
        stub_params_coverage_index_request
        response = Coverage.get(patientLastName: "Parker", patientFirstName: 'Peter')

        expect(response[:status]).to eq 200
        expect(response[:body]).not_to be_nil
      end
    end

    it "requests coverages by ID" do
      stub_single_coverage_request
      expect(URI).to receive(:parse).with("https://api.availity.com/demo/v1/coverages/123").and_call_original

      response = Coverage.get(123)

      expect(response[:status]).to eq 200
      expect(response[:body]).not_to be_nil
      expect(response[:body]['id']).to eq '123'
    end
  end

  describe ".delete" do
    it "requires an ID" do
      expect{ Coverage.delete }.to raise_error
    end

    it "issues request with correct params" do
      expect(AvailityClient).to receive(:issue_request)
        .with('delete', "https://api.availity.com/demo/v1/coverages/123", {})
        Coverage.delete(123)
    end
  end
end
