require 'spec_helper'

describe Game do
  it "should return a valid game from the factory" do
    Factory(:game).should be_valid
  end
end