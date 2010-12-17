module PivotalPlanningPoker
  class Project < TrackerEntity
    tracker_attribute :project_name, './name'
    tracker_attribute :project_id, './id'
    tracker_attribute :point_scale,'./point_scale'

    def point_scale_array
      point_scale.split(',')
    end

    def self.find(project_id, token)
      raise ArgumentError, "Project id must be defined" if project_id.nil?

      doc = Nokogiri::XML(Client.new(token).get("https://www.pivotaltracker.com/services/v3/projects/#{project_id}"))
      new(doc.xpath('/project'))
    end

    def self.for_user(user)
      doc = Nokogiri::XML(Client.new(user.token).get("https://www.pivotaltracker.com/services/v3/projects"))

      doc.xpath('/projects/project').map do |project_node|
        new(project_node)
      end
    end
  end
end