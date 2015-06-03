require 'spec_helper'

module TestRail
  describe Project do

    PROJECT = ENV['TEST_RAIL_PROJECT_ID'].to_i

    before(:all) {
      @project = TestRail::API.new(credentials).get_project(:id => PROJECT)
    }

    describe "Attributes" do


      it "has an id" do
        @project.id.should == PROJECT
      end

      it "has a name" do
        @project.name.should == "TestRail API Validation"
      end

    end

    describe "#new_suite" do
      it "adds a new suite" do
        suite = @project.new_suite(:name => "Cucumber features", :description => 'Cucumber BDD suite')
        suite.class.should == TestRail::Suite
      end
    end

    describe "#suites" do
      it "Retrieves suites via association" do
        @project.suites.should be_a Array
        @project.suites.first.should be_a TestRail::Suite
      end

    end
  end
end
