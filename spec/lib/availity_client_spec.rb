require 'spec_helper'

describe AvailityClient do
  describe ".premium_key?" do
    it "returns true if AVAILITY_API_KEY and AVAILITY_API_SECRET variables are present" do
      ENV['AVAILITY_API_KEY'] = 'fakeApiKeyHere'
      ENV['AVAILITY_API_SECRET'] = 'secretKey'
      expect(AvailityClient.premium_key?).to be true
    end

    it "returns false if AVAILITY_API_SECRET variable is missing" do
      ENV['AVAILITY_API_KEY'] = 'fakeApiKeyHere'
      ENV['AVAILITY_API_SECRET'] = nil
      expect(AvailityClient.premium_key?).to be false
    end

    it "returns false if AVAILITY_API_SECRET variable is missing" do
      ENV['AVAILITY_API_KEY'] = nil
      ENV['AVAILITY_API_SECRET'] = nil
      expect(AvailityClient.premium_key?).to be false
    end
  end

  describe ".generate_token" do
    it "returns an Availity Oauth Token" do
      ENV['AVAILITY_API_KEY'] = 'fakeApiKeyHere'
      ENV['AVAILITY_API_SECRET'] = 'secretKey'
      response = double(
                   body:  {"access_token" => "cmj7kkkhc2zmwv9ekseptneg","token_type" => "bearer","expires_in" => 300}.to_json,
                   status: 200)

      faraday = double()
      expect(Faraday).to receive(:new).and_return faraday
      expect(faraday).to receive(:post).and_return response
      expect(AvailityClient.generate_token).to eq 'cmj7kkkhc2zmwv9ekseptneg'
    end
  end

  describe ".issue_request" do
    before do
      ENV['AVAILITY_API_KEY'] = 'fakeApiKeyHere'
    end

    it "raises an error without AVAILITY_API_KEY Env Var" do
      ENV['AVAILITY_API_KEY'] = nil

      expect{
        AvailityClient.issue_request('get', 'http://example.com', {})
      }.to raise_error MissingApiKeyError
    end

    it "issues request based on provided parameters" do
      method = 'post'
      url = 'http://example.com'
      params = { foo: 'bar' }

      expect(URI).to receive(:parse).with(url).and_call_original
      allow_any_instance_of(Faraday::Connection).to receive(:post)
        .and_return(OpenStruct.new(status: 200, body: { foo: 'bar' }.to_json), headers: { "x-response" => "ok" })

      response = AvailityClient.issue_request(method, url, params)

      expect(response).to have_key(:headers)
      expect(response[:status]).to eq 200
      expect(response[:body]).to eq({ 'foo' => 'bar' })
    end
  end
end
