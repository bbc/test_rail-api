require 'spec_helper'

# Unit and integration tests relating to the testrail api
# This requires internet access to <yournamespace>.testrail.com
# and assumes a project with id of 1 exists -- it then performs 
# various actions on this
# project to exercise the API
module TestRail
  describe API do

    PROJECT = ENV['TEST_RAIL_PROJECT_ID'].to_i

    describe ".new" do
      it "errors without user" do
        expect {
          TestRail::API.new(:password  => 'aaa',
                            :namespace => 'mynamespace')
        }.to raise_error
      end
      it "errors without password" do
        expect {
          TestRail::API.new(:user      => 'aaa',
                            :namespace => 'mynamespace')
        }.to raise_error
      end
      it "errors without namespace" do
        expect {
          TestRail::API.new(:password => 'aaa',
                            :user     => 'aaa')
        }.to raise_error
      end

      it "Initializes a new testrail instance" do
        testrail = TestRail::API.new(credentials)
        testrail.class.should == TestRail::API
      end
    end

    describe "#server" do
      it "returns the server string" do
        server = TestRail::API.new(credentials).server
        server.should match(/.testrail.com/)
      end
    end

    #
    # Project information
    #
    describe "#get_projects" do
      it "returns a list of project objects" do
        testrail = TestRail::API.new(credentials)
        projects = testrail.get_projects
        projects.class.should == Array
        projects.first.class.should == TestRail::Project
      end

      it "returns a specific project" do
        testrail = TestRail::API.new(credentials)
        project  = testrail.get_project(:id => PROJECT)
        project.class.should == TestRail::Project
        project.id.should == PROJECT
      end

      it "errors if project doesn't exist" do
        testrail = TestRail::API.new(credentials)
        expect {
          project = testrail.get_project(:id => 99999)
        }.to raise_error
      end

    end

    describe "#find_project" do
      it "returns project based on name" do
        PROJECT_NAME = 'TestRail API Validation'
        testrail     = TestRail::API.new(credentials)
        project      = testrail.find_project(:name => PROJECT_NAME)
        project.id.should == PROJECT
        project.name.should == PROJECT_NAME
      end
      it "errors if project name doesnt exists" do
        testrail = TestRail::API.new(credentials)
        expect {
          testrail.find_project(:name => 'DOESNT_EXIST')
        }.to raise_error
      end
    end

    #
    # add_suite
    #
    describe "#add_suite" do
      it "adds a new suite" do
        testrail = TestRail::API.new(credentials)
        suite    = testrail.add_suite(:project_id => PROJECT, :name => "Cucumber features", :description => 'Cucumber BDD suite')
        suite.class.should == TestRail::Suite

        suite.project_id.should == PROJECT
        suite.name.should == "Cucumber features"
        suite.description.should == 'Cucumber BDD suite'
        suite.id.should >= 1
      end
      it "throws an error if project doesn't exist"
      it "errors if project id is not provided" do
        testrail = TestRail::API.new(credentials)
        expect {
          suite = testrail.add_suite(:name => "Cucumber features", :description => 'Cucumber BDD suite')
        }.to raise_error
      end
      it "errors if name is not provided" do
        testrail = TestRail::API.new(credentials)
        expect {
          suite = testrail.add_suite(:project_id => PROJECT, :description => 'Cucumber BDD suite')
        }.to raise_error
      end
    end

    describe "<Suite retrieval>" do
      before(:all) {
        @testrail = TestRail::API.new(credentials)
        @suite    = @testrail.add_suite(:project_id => PROJECT, :name => "Cucumber features", :description => 'Suite created for TestRail validation tests')
      }

      describe "#get_suites" do
        it 'Returns a list of suite objects' do
          suites = @testrail.get_suites(:project_id => PROJECT)
          suites.empty?.should == false
          suites.first.should be_a TestRail::Suite
        end
      end

      describe "#get_suite" do
        it "Returns a suite object by id" do
          suite = @testrail.get_suite(:id => @suite.id)
          suite.id.should == @suite.id
          suite.name.should == @suite.name
        end
        it "errors if suite does not exist"
      end

      describe "#update_suite" do
        it "Applies an update"
        it "errors if the suite does not exist"
      end

    end

    #
    # Sections
    #
    describe "#add_section" do
      before(:all) do
        @testrail = TestRail::API.new(credentials)
        @suite    = @testrail.get_suites(:project_id => PROJECT).first
      end

      it "adds a new section to a suite" do
        testrail = TestRail::API.new(credentials)
        section  = testrail.add_section(:project_id => PROJECT,
                                        :name       => "UI features",
                                        :suite_id   => @suite.id)

        section.class.should == TestRail::Section
      end
      it "throws an error if project doesn't exist"
      it "throws an error if the suite doesn't exist"
      it "errors with missing project id"
      it "errors with missing name"

      it "adds a sub-section" do
        testrail    = TestRail::API.new(credentials)
        section     = testrail.add_section(:project_id => PROJECT,
                                           :name       => "UI features",
                                           :suite_id   => @suite.id)
        sub_section = testrail.add_section(:project_id => PROJECT,
                                           :name       => "Logging in",
                                           :suite_id   => @suite.id,
                                           :parent_id  => section.id)

        sub_section.class.should == TestRail::Section
        sub_section.parent_id.should == section.id
      end
    end

    describe "#get_sections" do
      before(:all) do
        @testrail = TestRail::API.new(credentials)
        @suite    = @testrail.get_suites(:project_id => PROJECT).first
      end

      it 'gets a list of sections' do
        sections = @testrail.get_sections(:project_id => PROJECT, :suite_id => @suite.id)
        sections.first.should be_a TestRail::Section
      end
    end

    describe "#add_case" do
      before(:all) do
        @testrail = TestRail::API.new(credentials)
        @suite    = @testrail.get_suites(:project_id => PROJECT).first
        @section  = @testrail.add_section(:project_id => PROJECT,
                                          :name       => "UI features",
                                          :suite_id   => @suite.id)
      end

      it 'adds a case to a section' do
        testcase = @testrail.add_case(:project_id => PROJECT,
                                      :suite_id   => @suite.id,
                                      :section_id => @section.id,
                                      :title      => 'User logs in')
        testcase.should be_a TestRail::TestCase
        testcase.id.should >= 1
      end

    end

    describe "#get_cases" do
      before(:all) do
        @testrail = TestRail::API.new(credentials)
        @suite    = @testrail.get_suites(:project_id => PROJECT).first
        @section  = @testrail.add_section(:project_id => PROJECT,
                                          :name       => "UI features",
                                          :suite_id   => @suite.id)
        @testrail.add_case(:project_id => PROJECT, :suite_id => @suite.id, :section_id => @section.id, :title => "User logs in")
      end

      it "Retrieves all cases belonging to the suite" do
        test_cases = @testrail.get_cases(:project_id => PROJECT, :suite_id => @suite.id)
        test_cases.should be_a Array
        test_cases.first.should be_a TestRail::TestCase
      end

      it "Retrieves all cases belonging to the section" do
        test_cases = @testrail.get_cases(:project_id => PROJECT, :suite_id => @suite.id, :section_id => @section.id)
        test_cases.should be_a Array
        test_cases.first.should be_a TestRail::TestCase
      end
    end

    describe "#get_case_types" do
      before(:all) do
        @testrail = TestRail::API.new(credentials)
      end
      
      it "Retrieves an array of case types" do
        case_types = @testrail.get_case_types
        case_types.should be_a Array
        case_types.first.should be_a TestRail::CaseType
        case_types.first.id.should == 1
        case_types.first.name.should == 'Automated'
      end
    end

    describe "#get_priorities" do
      before(:all) do
        @testrail = TestRail::API.new(credentials)
      end

      it "Retrieves an array of priorities" do
        case_types = @testrail.get_priorities
        case_types.should be_a Array
        case_types.first.should be_a TestRail::Priority
        case_types.first.id.should be_a Fixnum
        case_types.first.name.should be_a String
      end
    end

    describe "#add_run" do
      before(:all) do
        @testrail = TestRail::API.new(credentials)
        @suite    = @testrail.add_suite(:project_id => PROJECT, :name => "Cucumber features", :description => 'Suite created for TestRail validation tests')
      end

      it "Creates a new run" do
        run = @testrail.add_run( :project_id => PROJECT, :suite_id => @suite.id, :name => 'Test run', :description => 'Some run or other')
        run.should be_a TestRail::Run
        run.id.should be_a Fixnum
        run.name.should == 'Test run'
        run.description.should == 'Some run or other'
      end
    end

  end
end
