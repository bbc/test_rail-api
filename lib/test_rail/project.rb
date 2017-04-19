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

    # Return a list of plans belonging to this project
    def plans
      @api.get_plans( :project_id => @id )
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

    # Create a new plan for this project
    def new_plan( args )
      @api.add_plan( args.merge({:project_id => id}) )
    end

    # Find a plan in this project based on the plan name
    # project.find_plan( :name => "My Plan" )
    def find_plan( args )
      name = args[:name] or raise "Need to provide the name of plan"
      plans.select{ |s| s.name == name }.first
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

    def find_or_create_plan( args )
      name =args[:name] or raise "Need to provide name of plan"
      plan = self.find_plan( args )
      if plan.nil?
        plan = new_plan( args )
      end
      plan
    end

  end
end
