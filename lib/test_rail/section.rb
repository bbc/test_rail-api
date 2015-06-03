module TestRail
  class Section
    include Virtus.model
    include InitializeWithApi

    attribute :id
    attribute :name
    attribute :project_id
    attribute :parent_id
    attribute :url
    attribute :suite_id

    def update
      @api.update_section( :section_id => @id, :name => name, :project_id => @project_id, :suite_id => @suite_id, :parent_id => @id)
    end

    # Get a list of sub-sections
    def sub_sections
      sections = @api.get_sections( :project_id => @project_id, :suite_id => @suite_id )
      sections.reject{ |s| s.parent_id != @id }
    end

    # Get a list of test-cases
    def test_cases
      @api.get_cases( :project_id => @project_id, :suite_id => @suite_id, :section_id => @id )
    end

    def new_test_case(args)
      @api.add_case(args.merge({:section_id => @id }))
    end

    def find_test_case( args )
      title = args[:title] or raise "Need to provide the title of a test case"
      test_cases.select{ |c| c.title == title }.first
    end

    def find_or_create_test_case( args )
      title = args[:title] or raise "Need to provide the title of a test case"
      test_case = self.find_test_case( args )
      if test_case.nil?
        test_case = new_test_case( args )
      end
      test_case
    end

    # suite.add_section( :name => 'Section name )
    def add_section( args )
      @api.add_section( :project_id => project_id, :parent_id => @id, :suite_id => @suite_id, :name =>  args[:name] )
    end

    def find_section( args )
      name = args[:name] or raise "Need to provide the sub-section name (:name => 'subsection01')"
      sub_sections.select{ |s| s.name == name }.first
    end

    def find_or_create_section( args )
      name = args[:name] or raise "Need to provide the sub-section name (:name => 'subsection01')"
      section = self.find_section( args )
      if section.nil?
        section = add_section( args )
      end
      section
    end
  end
end
