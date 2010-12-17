require 'spec_helper'

describe HomeController do
  describe "GET #index" do
    it "should assign a user with the given params" do
      get :index
      assigns[:user].should_not be_nil
    end

    describe "with integrated views" do
      render_views
      
      it "should respond successfully" do
        get :index
        response.should be_success
      end
    end
  end
end