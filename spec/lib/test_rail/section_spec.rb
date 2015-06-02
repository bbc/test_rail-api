require 'spec_helper'

module TestRail
  describe Section do

    PROJECT_ID = ENV['TEST_RAIL_PROJECT_ID'].to_i

    before(:all) {
      @testrail    = TestRail::API.new(credentials)
      @suite       = @testrail.add_suite(:project_id => PROJECT_ID, :name => "Cucumber features", :description => 'Suite created for TestRail validation tests')
      @section     = @testrail.add_section(:project_id => PROJECT_ID, :suite_id => @suite.id, :name => 'UI features')
      @sub_section = @testrail.add_section(:project_id => PROJECT_ID, :suite_id => @suite.id, :parent_id => @section.id, :name => 'Logging in')
      @testrail.add_case(:section_id => @sub_section.id, :title => 'User signs up for account')
    }

    describe "#update" do
      it "Applies an update" do
        @section.name = "Section description updated"
        section       = @section.update
        section.name.should == @section.name
      end
    end

    describe "#sub_sections" do

      it "Retrieves sections list" do
        sections = @section.sub_sections
        sections.should be_a Array
        sections.first.should be_a TestRail::Section
      end
    end

    describe '#new_test_case' do
      it 'creates a new test case' do
        test_case = @sub_section.new_test_case(:title => 'User logs in')
        test_case.should be_a TestRail::TestCase
        test_case.title.should == 'User logs in'
      end
    end

    describe '#test_cases' do
      it 'returns a list of test cases' do
        test_cases = @sub_section.test_cases
        test_cases.should be_a Array
        test_cases.first.should be_a TestRail::TestCase
      end
    end
  end
end
