require 'spec_helper'
require 'availity_client/configuration'
require 'support/common_stubs'

describe Configuration do

  before do
    ENV['AVAILITY_API_KEY'] = 'fakeApiKeyHere'
  end

  describe ".get" do
    it "makes proper HTTP request" do
      expect(AvailityClient).to receive(:issue_request)
        .with(
          'get', 'https://api.availity.com/demo/v1/configurations', { type: 270 }
        ).and_return nil

      Configuration.get(type: 270)
    end
  end
end
