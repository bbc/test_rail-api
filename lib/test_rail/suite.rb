module TestRail
  class Suite
    include Virtus.model
    include InitializeWithApi

    attribute :id
    attribute :name
    attribute :description
    attribute :project_id
    attribute :url

    # Save changes made to this object back in testrail
    # suite.description = "New description"
    # suite.update
    def update
      @api.update_suite( :id => @id, :name => @name, :description => @description)
    end

    # Get a list of sections for this suite
    def sections
      sections = @api.get_sections( :project_id => @project_id, :suite_id => @id )
      sections.reject{ |s| s.parent_id != nil }
    end

    # suite.add_section( :name => 'Section name )
    def add_section( args)
      @api.add_section( :project_id => project_id, :suite_id => @id, :name =>  args[:name] )
    end

    def find_section( args )
      name = args[:name] or raise "Need to provide the section name"
      sections.select{ |s| s.name == name }.first
    end

    def find_or_create_section( args )
      name = args[:name] or raise "Need to provide the section name"
      section = self.find_section( args )
      if section.nil?
        section = add_section( args )
      end
      section
    end
  end
end
