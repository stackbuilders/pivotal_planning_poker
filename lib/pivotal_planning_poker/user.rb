module PivotalPlanningPoker

  class User
    attr_accessor :username, :password, :token, :user_id

    def initialize(params = {})
      @username = params[:username]
      @password = params[:password]
      @token    = params[:token]
      @user_id  = params[:user_id]
    end

    def projects
      Project.for_user(self)
    end

    def authenticate!
      resp = Curl::Easy.perform('https://www.pivotaltracker.com/services/v3/tokens/active') do |curl|
        curl.userpwd = "#{username}:#{password}"
      end.body_str

      if resp !~ /Access denied/
        doc = Nokogiri::XML(resp)

        @token    = doc.xpath('//guid').text
        @user_id  = doc.xpath('//id').text

        true
      else

        false
      end
    end
  end
end