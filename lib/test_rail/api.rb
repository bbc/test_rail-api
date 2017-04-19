module TestRail
  class API
    attr_accessor :server

    TESTRAIL = 'testrail.com'
    HEADERS  = { "Content-Type" => "application/json" }

    STATUSES = {
        :passed   => 1,
        :pass     => 1,
        :blocked  => 2,
        :untested => 3,
        :retest   => 4,
        :failed   => 5,
        :fail     => 5
    }


    # Initialize a new tesrail interface
    # TestRail.new( :user      => 'your@email.com',
    #               :password  => 'passw0rd',
    #               :namespace => 'yourteam' )
    def initialize(args)
      raise "Need to provide arguments to constructor" if !args
      @user = args[:user] or raise "Missing username (:user => 'email@address.com')"
      @password = args[:password] or raise "Missing password (:password => 'abc123')"
      @namespace = args[:namespace] or raise "Missing namespace (:namespace => 'testteam')"

      @server = @namespace + "." + TESTRAIL
      @host   = URI('https://' + @server)
      @api    = "/index.php?/api/v2/"
      @port   = 443

    end

    #
    # Project API calls
    #

    # Return a list of projects
    def get_projects
      list = get('get_projects')
      list.collect do |item|
        TestRail::Project.new(item.merge({ :api => self }))
      end
    end

    # Return a specific project by id
    # api.get_project( :id => 1 )
    def get_project(args)
      id = args[:id] or raise "Missing id (:id => 1)"
      project = get('get_project', [id])
      TestRail::Project.new(project.merge({ :api => self }))
    end

    # Search for a project by name
    # testrail.find_project(:name => 'Amazing project')
    def find_project(args)
      name = args[:name] or raise "Missing name (:name => 'Amazing Project')"
      projects      = get_projects
      projectexists = projects.select { |p| p.name == name }.first
      if (!projectexists)
        raise "Project Not Found."
      end
      return projectexists
    end

    #
    # Plan API calls
    #

    # Add a new plan
    # (If plan already exists, a new one is created with the same name)
    # api.add_plan( :project_id => 1, :name => 'My new Plan', :description => 'Test Plan' )
    # Returns the plan object
    def add_plan(args)
      project_id = args[:project_id] or raise 'Missing project id (:project_id => 1)'
      name = args[:name] or raise 'Missing plan name (:name => "My Test Plan")'
      description = args[:description]

      plan = post('add_plan', [project_id], { :name => name, :description => description })
      TestRail::Plan.new(plan.merge({ :api => self }))
    end

    # Get a list of plans for a project
    # api.get_plans( :project_id => 1 )
    # Returns a list of plan objects
    def get_plans(args)
      id = args[:project_id] or raise "Missing project id (:project_id => 1)"
      list = get('get_plans', [id])
      list.collect do |item|
        TestRail::Plan.new(item.merge({ :api => self }))
      end
    end

    # Given a plan id, returns a plan (and populates internal run objects)
    def get_plan(args)
      plan_id = args[:plan_id] or raise "Missing plan id (:plan_id => 1)"
      result = get('get_plan', [plan_id])
      raw_runs = result['entries'].collect { |e| e['runs'] }.flatten
      runs     = raw_runs.each.collect { |r| TestRail::Run.new(r.merge({ :api => self })) }
      plan = TestRail::Plan.new(result.merge({ :api => self, :runs => runs }))
      plan
    end
 
    def update_plan(args)
      id = args[:id] or raise "Missing plan id (:id => 1)"
      name        = args[:name]
      description = args[:description]

      plan = post('update_plan', [id], { :name => name, :description => description })
      TestRail::Plan.new(plan.merge({ :api => self }))
    end

    #
    # Suite API calls
    #

    # Add a new suite
    # (If suite already exists, a new one is created with the same name)
    # api.add_suite( :project_id => 1, :name => 'Cucumber features', :description => 'BDD Tests' )
    # Returns the suite object
    def add_suite(args)
      project_id = args[:project_id] or raise 'Missing project id (:project_id => 1)'
      name = args[:name] or raise 'Missing name (:name => "Cucumber features")'
      description = args[:description]

      suite = post('add_suite', [project_id], { :name => name, :description => description })
      TestRail::Suite.new(suite.merge({ :api => self }))
    end

    # Get a list of suites for a project
    # api.get_suites( :project_id => 1 )
    # Returns a list of suite objects
    def get_suites(args)
      id = args[:project_id] or raise "Missing project id (:project_id => 1)"
      list = get('get_suites', [id])
      list.collect do |item|
        TestRail::Suite.new(item.merge({ :api => self }))
      end
    end

    # Get an existing suite by id
    # testrail.get_suite( :id => 1 )
    # Returns the suite object
    def get_suite(args)
      id = args[:id] or raise "Missing suite id (:id => 1)"
      suite = get('get_suite', [id])
      TestRail::Suite.new(suite.merge({ :api => self }))
    end

    def update_suite(args)
      id = args[:id] or raise "Missing suite id (:id => 1)"
      name        = args[:name]
      description = args[:description]

      suite = post('update_suite', [id], { :name => name, :description => description })
      TestRail::Suite.new(suite.merge({ :api => self }))
    end

    #
    # Section API Calls
    #
    def add_section(args)
      project_id = args[:project_id] or raise 'Missing project id (:project_id => 1)'
      name = args[:name] or raise 'Missing name (:name => "UI features")'
      suite_id = args[:suite_id] or raise 'Missing suite id (:suite_id => 1)'
      parent_id = args[:parent_id]

      section = post('add_section', [project_id], { :suite_id => suite_id, :name => name, :parent_id => parent_id })
      TestRail::Section.new(section.merge({ :api => self, :project_id => project_id, :suite_id => suite_id }))
    end

    def get_sections(args)
      project_id = args[:project_id] or raise 'Missing project id (:project_id => 1)'
      suite_id = args[:suite_id] or raise 'Missing suite id (:suite_id => 1)'
      list = get('get_sections', [project_id], { :suite_id => suite_id })
      list.collect do |item|
        TestRail::Section.new(item.merge({ :api => self, :project_id => project_id }))
      end
    end

    def update_section(args)
      section_id = args[:section_id] or raise 'Missing section id (:section_id => 1)'
      project_id = args[:project_id] or raise 'Missing project id (:project_id => 1)'
      name = args[:name] or raise 'Missing name (:name => "UI features")'
      suite_id = args[:suite_id] or raise 'Missing suite id (:suite_id => 1)'
      parent_id = args[:parent_id]

      section = post('update_section', [section_id], { :suite_id => suite_id, :name => name, :parent_id => parent_id })
      TestRail::Section.new(section.merge({ :api => self, :project_id => project_id }))
    end

    #
    # Testcase API
    #
    def get_cases(args)
      project_id = args[:project_id] or raise 'Missing project id (:project_id => 1)'
      suite_id = args[:suite_id] or raise 'Missing suite id (:suite_id => 1)'
      section_id = args[:section_id]
      list       = get('get_cases', [project_id], { :suite_id => suite_id, :section_id => section_id })
      list.collect do |item|
        TestRail::TestCase.new(item.merge({ :api => self }))
      end
    end

    def get_case(args)
      case_id = args[:case_id] or raise 'Missing test case id (:case_id => 1)'
      testcase = get('get_case', [case_id])
      TestRail::TestCase.new(testcase.merge({ :api => self }))
    end

    def add_case(args)
      section_id = args[:section_id] or raise 'Missing section id (:section_id => 1)'
      title = args[:title] or raise 'Missing title (:title => "Use logs in")'
      steps = args[:steps]
      type_id = args[:type_id]
      priority_id = args[:priority_id]

      test_case = post('add_case', [section_id],
                         { :title => title, :custom_steps => steps,
                           :type_id => type_id, :priority_id => priority_id })
      
      TestRail::TestCase.new(test_case.merge({ :api => self }))
    end

    def update_case(args)
      case_id = args[:case_id] or raise "Missing case id (:case_id => 1)"
      
      new_values = {}

      new_values[:title] = args[:title] if args[:title]
      new_values[:custom_steps] = args[:steps] if args[:steps]
      new_values[:priority_id] = args[:priority_id] if args[:priority_id] 
      new_values[:type_id] = args[:type_id] if args[:type_id]

      test_case = post('update_case', [case_id], new_values )
      
      TestRail::TestCase.new(test_case.merge({ :api => self }))
    end

    #
    # Results API
    #
    def add_result_for_case(args)
      run_id = args[:run_id] or raise "Missing test run id (:run_id => 1)"
      case_id = args[:case_id] or raise "Missing test case id (:case_id => 1)"

      status_id = args[:status_id]
      if !status_id
        status_id = STATUSES[args[:status].to_sym]
        raise "Couldn't determine result status '#{args[:status]}'" if !status_id
      end

      result = {
          :status_id => status_id,
          :comment   => args[:comment],
          :version   => args[:version],
          :elapsed   => args[:elapsed]
      }

      test_rail_result = post('add_result_for_case', [run_id, case_id], result)
      #TODO new this into a relevant TestRails object
    end

    # Given a run id, retrieve a plan
    def get_run(args)
      run_id = args[:run_id] or raise "Missing run id ( :run_id => 1)"

      result = get('get_run', [run_id])
      TestRail::Run.new(result.merge({ :api => self }))
    end

    # Creates a new run
    # api.add_run( :project_id => project_id, :suite_id => suite_id )
    # Optional parameters:
    # name: Name to give the run
    # description: Description of the run
    def add_run(args)
      project_id = args[:project_id] or raise "Missing project id ( :project_id => 1)"
      suite_id = args[:suite_id] or raise "Missing suite id ( :suite_id => 1)"

      params = { 
                 :suite_id => suite_id,
                 :name     => args[:name],
                 :description => args[:description] 
               }

      result = post('add_run', [project_id], params)
      TestRail::Run.new(result.merge({ :api => self }))
    end

    # Add a new run in test plan
    # api.add_run_in_plan( :project_id => project_id, :plan_id => plan_id, :suite_id => suite_id )
    def add_run_in_plan(args)
      project_id = args[:project_id] or raise "Missing project id ( :project_id => 1)"
      plan_id = args[:plan_id] or raise "Missing project id ( :project_id => 1)"
      suite_id = args[:suite_id] or raise "Missing suite id ( :suite_id => 1)"

      params = { 
                 :project_id => project_id,
                 :suite_id => suite_id,
                 :name     => args[:name],
                 :description => args[:description] 
               }
      result = post('add_plan_entry', [plan_id], params)["runs"][0]
      TestRail::Run.new(result.merge({ :api => self }))
    end

    def get_tests(args)
      run_id = args[:run_id] or raise "Missing run id (:run_id => 1)"
      list = get('get_tests', [run_id])

      list.collect do |item|
        TestRail::Test.new(item.merge({ :api => self }))
      end
    end

    # Get all the case types defined for this testrail instance
    def get_case_types
      result = get('get_case_types')

      result.collect do |type|
        TestRail::CaseType.new(type.merge({ :api => self  }))
      end
    end    

    # Get all the priorities defined for this testrail instance
    def get_priorities
      result = get('get_priorities')

      result.collect do |priority|
        TestRail::Priority.new(priority.merge({ :api => self  }))
      end
    end


    #
    # Private methods
    #
    private

    # Creates and caches an http object that is used by the get and
    # post commands
    def http
      if !@http
        path = @host.to_s + @api
        uri  = URI.parse(path)

        proxy_env = ENV['HTTP_PROXY']

        if proxy_env
          proxy_uri = URI(proxy_env)
          proxy     = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port)
          @http     = proxy.new(uri.host, uri.port)
        else
          @http = Net::HTTP.new(uri.host, uri.port)
        end
        @http.use_ssl     = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      @http
    end

    def get(call, array_args=[], hash_args={})
      send_request('get', call, array_args, hash_args, nil)
    end

    def post(call, array_args=[], post_args={})
      send_request('post', call, array_args, nil, post_args)
    end

    # get request
    def send_request(protocol, call, array_args = [], hash_args = {}, post_data = {})
      path = @host.to_s + @api + call
      if array_args
        path += '/' + array_args.join('/')
      end
      if hash_args
        path += '&' + hash_args.map { |k, v| "#{k.to_s}=#{v}" }.join('&')
      end
      uri = URI.parse(path)

      request = nil
      if protocol == 'get'
        request = Net::HTTP::Get.new(uri.request_uri, HEADERS)
      else
        request      = Net::HTTP::Post.new(uri.request_uri, HEADERS)
        request.body = post_data.to_json
      end
      request.basic_auth(@user, @password)

      response = http.request(request)

      body = JSON.parse(response.body)

      if response.code && response.code.to_i == 200
        return body
      else
        raise body["error"].to_s
      end
    end
  end
end
