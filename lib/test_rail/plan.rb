module TestRail
  class Plan
    include Virtus.model

    attribute :id
    attribute :name
    attribute :description
    attribute :milestone_id
    attribute :assignedto_id
    attribute :is_completed
    attribute :completed_on
    attribute :project_id
    attribute :created_on
    attribute :created_by
    attribute :url
    attribute :entries
    attribute :runs, Array

    class << self
      def find_by_id(plan_id)
        TestRail.get_plan(plan_id: plan_id)
      end
    end
  end
end
