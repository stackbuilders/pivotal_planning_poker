module PivotalPlanningPoker
  class InvalidResponseError < StandardError ; end

  class Client
    attr_reader :token

    def initialize(token)
      @token = token
    end

    def get(url)
      response = Curl::Easy.perform(url) do |curl|
        curl.headers = {'X-TrackerToken' => token}
      end

      if response.response_code != 200 || response.body_str == 'Access denied.'
        raise InvalidResponseError, "Invalid response received (Code - #{response.response_code}): Response: #{response.body_str}"
      end

      response.body_str
    end
  end
end