require 'spec_helper'

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
