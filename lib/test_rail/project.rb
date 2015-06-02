module TestRail
  class Project
    include Virtus.model
    include InitializeWithApi

    attribute :id
    attribute :name
    attribute :announcement
    attribute :show_announcement
    attribute :is_completed
    attribute :completed_on
    attribute :url

    # Return a list of suites belonging to this project
    def suites
      @api.get_suites( :project_id => @id )
    end

    # Create a new suite for this project
    def new_suite( args )
      @api.add_suite( args.merge({:project_id => id}) )
    end

    # Find a suite in this project based on the suite name
    # project.find_suite( :name => "My Suite" )
    def find_suite( args )
      name = args[:name] or raise "Need to provide the name of a suite"
      suites.select{ |s| s.name == name }.first
    end

    # Find or create a suite in this project based on the suite name
    # project.find_or_create_suite( :name => "My Suite" )
    def find_or_create_suite( args )
      name = args[:name] or raise "Need to provide the name of a suite"
      suite = self.find_suite( args )
      if suite.nil?
        suite = new_suite( args )
      end
      suite
    end
  end
end
