module TestRail
  class Run
    include Virtus.model
    include InitializeWithApi

    attribute :id
    attribute :suite_id
    attribute :name
    attribute :description
    attribute :milestone_id
    attribute :assignedto_id
    attribute :include_all
    attribute :is_completed
    attribute :completed_on
    attribute :config
    attribute :url
    attribute :passed_count
    attribute :blocked_count
    attribute :untested_count
    attribute :retest_count
    attribute :failed_count

    def tests
      @api.get_tests(:run_id => id)
    end

    def suite
      @api.get_suite(:id => suite_id)
    end
  end
end
