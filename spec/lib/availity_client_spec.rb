require 'spec_helper'

describe ".issue_request" do
  before do
    ENV['AVAILITY_API_KEY'] = 'fakeApiKeyHere'
  end

  it "raises an error without AVAILITY_API_KEY Env Var" do
    ENV['AVAILITY_API_KEY'] = nil

    expect{
      AvailityClient.issue_request('get', 'http://example.com', {})
    }.to raise_error MissingApiKey
  end

  it "issues request based on provided parameters" do
    method = 'post'
    url = 'http://example.com'
    params = { foo: 'bar' }

    expect(URI).to receive(:parse).with(url).and_call_original
    expect_any_instance_of(Faraday::Connection).to receive(:post)
      .and_return(OpenStruct.new(status: 200, body: {}.to_json))

    AvailityClient.issue_request(method, url, params)
  end
end
