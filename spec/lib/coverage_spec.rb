require 'spec_helper'
require 'availity_client/coverage'
require 'support/common_stubs'

describe Coverage do
  before do
    ENV['AVAILITY_API_KEY'] = 'fakeApiKeyHere'
  end

  describe ".get" do
    it "raises an error without AVAILITY_API_KEY Env Var" do
      ENV['AVAILITY_API_KEY'] = nil
      expect{
        Coverage.get
      }.to raise_error AvailityClient::MissingApiKey
    end

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
      end
    end
  end
end
