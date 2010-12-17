require 'spec_helper'

describe PivotalPlanningPoker::Story do
  describe "tracker attributes" do
    it "should assign the name from the name attribute" do
      story_node = Nokogiri::XML('<story><name>story name</name></story>')
      PivotalPlanningPoker::Story.new(story_node.xpath('/story')).story_name.should == 'story name'
    end

    it "should assign the story_id from the id attribute" do
      story_node = Nokogiri::XML('<story><id>42</id></story>')
      PivotalPlanningPoker::Story.new(story_node.xpath('/story')).story_id.should == '42'
    end

    it "should assign the project_id from the project_id attribute" do
      story_node = Nokogiri::XML('<story><project_id>proj id</project_id></story>')
      PivotalPlanningPoker::Story.new(story_node.xpath('/story')).project_id.should == 'proj id'
    end

    it "should assign the description from the description attribute" do
      story_node = Nokogiri::XML('<story><description>story des</description></story>')
      PivotalPlanningPoker::Story.new(story_node.xpath('/story')).description.should == 'story des'
    end

    it "should assign the story_type from the story_type attribute" do
      story_node = Nokogiri::XML('<story><story_type>story type</story_type></story>')
      PivotalPlanningPoker::Story.new(story_node.xpath('/story')).story_type.should == 'story type'
    end

    it "should assign the estimate from the estimate attribute" do
      story_node = Nokogiri::XML('<story><estimate>1</estimate></story>')
      PivotalPlanningPoker::Story.new(story_node.xpath('/story')).estimate.should == '1'
    end

    it "should assign the requested_by from the requested_by attribute" do
      story_node = Nokogiri::XML('<story><requested_by>Justin</requested_by></story>')
      PivotalPlanningPoker::Story.new(story_node.xpath('/story')).requested_by.should == 'Justin'
    end

    it "should assign the current_status from the current_status attribute" do
      story_node = Nokogiri::XML('<story><current_status>story status</current_status></story>')
      PivotalPlanningPoker::Story.new(story_node.xpath('/story')).current_status.should == 'story status'
    end
  end
end