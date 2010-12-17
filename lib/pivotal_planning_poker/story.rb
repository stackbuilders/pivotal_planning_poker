module PivotalPlanningPoker
  class Story < TrackerEntity
    tracker_attribute :story_name, './name'
    tracker_attribute :story_id, './id'
    tracker_attribute :project_id, './project_id'
    tracker_attribute :description, './description'
    tracker_attribute :story_type, './story_type'
    tracker_attribute :estimate, './estimate'
    tracker_attribute :requested_by, './requested_by'
    tracker_attribute :current_status, './current_status'

    def self.find(project_id, story_id, token)
      client = Client.new(token)
      resp = client.get("https://www.pivotaltracker.com/services/v3/projects/#{project_id}/stories/#{story_id}")
      new(Nokogiri::XML(resp).xpath('/story'))
    end

    def update_estimate(estimate, token)
      Curl::Easy.perform("https://www.pivotaltracker.com/services/v3/projects/#{project_id}/stories/#{story_id}") do |curl|
        curl.headers  = {'X-TrackerToken' => token, 'Content-type' => 'application/xml'}
        curl.put_data = "<story><estimate>#{estimate}</estimate></story>"
      end
    end

    def self.for_project(project, token)
      client = Client.new(token)
      resp   = client.get("https://www.pivotaltracker.com/services/v3/projects/#{project.project_id}/stories")

      Nokogiri::XML(resp).xpath('/stories/story').map do |story_node|
        new(story_node)
      end
    end
  end
end