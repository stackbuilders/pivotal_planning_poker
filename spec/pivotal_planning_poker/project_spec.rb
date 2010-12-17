require 'spec_helper'

describe PivotalPlanningPoker::Project do
  describe "tracker attributes" do
    it "should find the project name from the name element" do
      PivotalPlanningPoker::Project.new(Nokogiri::XML('<tracker><name>my project</project></tracker>').xpath('/tracker')).project_name.should == 'my project'
    end

    it "should find the project_id from the id element" do
      PivotalPlanningPoker::Project.new(Nokogiri::XML('<tracker><id>42</id></tracker>').xpath('/tracker')).project_id.should == '42'
    end

    it "should find the point scale from the point_scale element" do
      PivotalPlanningPoker::Project.new(Nokogiri::XML('<tracker><point_scale>1,2,3</point_scale></tracker>').xpath('/tracker')).point_scale.should == '1,2,3'
    end
  end
end