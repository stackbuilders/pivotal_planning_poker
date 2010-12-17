require 'spec_helper'

describe PivotalPlanningPoker::Client do
  describe "initialization" do
    it "should be initialized with a token" do
      PivotalPlanningPoker::Client.new('footoken').token.should == 'footoken'
    end
  end

  describe "#get" do
    it "should call Curl with the token for a get request and return the body string of the response" do
      token = 'toktok'

      curl_config = mock('curl_config')
      curl_config.should_receive(:headers=).with({'X-TrackerToken' => token})

      curl_easy = mock('curl_easy', :response_code => 200)
      curl_easy.should_receive(:body_str).any_number_of_times.and_return('the body')
      
      Curl::Easy.should_receive(:perform).with('url').and_yield(curl_config).and_return(curl_easy)
      client = PivotalPlanningPoker::Client.new(token)
      
      client.get('url').should == 'the body'
    end

    it "should raise ErrorResponseReceived error if the client does not have access to this resource" do
      token = 'toktok'

      curl_config = mock('curl_config')
      curl_config.should_receive(:headers=).with({'X-TrackerToken' => token})

      curl_easy = mock('curl_easy', :response_code => 200)
      curl_easy.should_receive(:body_str).any_number_of_times.and_return('Access denied.')

      Curl::Easy.should_receive(:perform).with('url').and_yield(curl_config).and_return(curl_easy)
      client = PivotalPlanningPoker::Client.new(token)

      lambda {
        client.get('url')
      }.should raise_error(PivotalPlanningPoker::InvalidResponseError)
    end

    it "should raise ErrorResponseReceived if we do not receive a 200 response" do
      token = 'toktok'

      curl_config = mock('curl_config')
      curl_config.should_receive(:headers=).with({'X-TrackerToken' => token})

      curl_easy = mock('curl_easy', :response_code => 401)
      curl_easy.should_receive(:body_str).and_return('All good, full steam ahead.')

      Curl::Easy.should_receive(:perform).with('url').and_yield(curl_config).and_return(curl_easy)
      client = PivotalPlanningPoker::Client.new(token)

      lambda {
        client.get('url')
      }.should raise_error(PivotalPlanningPoker::InvalidResponseError)
    end
  end

end