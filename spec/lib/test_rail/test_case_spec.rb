require 'spec_helper'

module TestRail
  describe TestCase do

    PROJECT_ID = ENV['TEST_RAIL_PROJECT_ID'].to_i

    before(:all) {
      @testrail  = TestRail::API.new(credentials)
      @suite     = @testrail.add_suite(:project_id => PROJECT_ID, :name => "Cucumber features", :description => 'Suite created for TestRail validation tests')
      @section   = @testrail.add_section(:project_id => PROJECT_ID, :suite_id => @suite.id, :name => 'UI features')
      @test_case = @testrail.add_case(:section_id => @section.id, :title => 'User signs up for account', :type_id => 1)
    }

    describe "#update" do
      it "Applies an update" do
        @test_case.title = "Section description updated"
        test_case        = @test_case.update
        test_case.title.should == @test_case.title
      end
    end
  end
end
