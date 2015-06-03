module TestRail
  class TestCase
    include Virtus.model
    include InitializeWithApi

    attribute :id
    attribute :title
    attribute :type_id
    attribute :priority_id
    attribute :estimate
    attribute :milestone_id
    attribute :refs
    attribute :url

    # Save changes made to this object back in testrail
    def update
      @api.update_case( :case_id => @id, :title => @title )
    end
 
    def add_result( args )
      run_id = args[:run_id] or raise "Need to provide a run ID to store result against"
      status = args[:status] or raise "Need to provide a result status (e.g. :status => :passed)"
      version = args[:version]
      @api.add_result_for_case( :case_id => id, :run_id => run_id, :status => status, :version => version )
    end
  end
end
