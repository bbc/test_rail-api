require 'spec_helper'

module TestRail
  describe Suite do

    PROJECT_ID = ENV['TEST_RAIL_PROJECT_ID'].to_i

    before(:all) {
      @testrail = TestRail::API.new(credentials)
      @suite    = @testrail.add_suite(:project_id => PROJECT_ID, :name => "Cucumber features", :description => 'Suite created for TestRail validation tests')
    }

    describe "#update" do
      it "Applies an update" do
        @suite.description = "Suite description updated"
        suite              = @suite.update
        suite.description.should == @suite.description
      end
    end

    describe "#sections" do

      before(:all) {
        @testrail.add_section(:project_id => PROJECT_ID, :suite_id => @suite.id, :name => 'UI Features')
      }

      it "Retrieves sections list" do
        sections = @suite.sections
      end
    end
  end
end
