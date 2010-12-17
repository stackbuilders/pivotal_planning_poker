require 'spec_helper'

describe PivotalPlanningPoker::TrackerEntity do
  describe "initialization" do
    it "should set @doc to the given input if it responds to xpath" do
      doc = mock('doc', :xpath => :woof)
      PivotalPlanningPoker::TrackerEntity.new(doc).doc.should == doc
    end
  end

  describe ".register_attribute" do
    it "should create a reader method based on the given parameters" do
      class SomeEntity < PivotalPlanningPoker::TrackerEntity
        tracker_attribute :stuff, '/stuff'
      end
      
      SomeEntity.new(Nokogiri::XML('<stuff>hey</stuff>')).stuff.should == 'hey'
    end

    it "should raise an error if a method already exists with the name of the given attribute" do
      lambda {
        class SomeEntity < PivotalPlanningPoker::TrackerEntity
          def some_weird_method ; end
          tracker_attribute :some_weird_method, '/foofoo'
        end
      }.should raise_error(ArgumentError)
    end
  end
end