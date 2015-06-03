module TestRail
  class Test
    include Virtus.model
    
    attribute :id
    attribute :case_id
    attribute :status_id
    attribute :assignedto_id
    attribute :run_id
    attribute :title
    attribute :type_id
    attribute :priority_id
    attribute :estimate
    attribute :estimate_forcast
    attribute :custom_steps

  end
end
