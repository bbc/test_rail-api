module TestRail
  class Result
    include Virtus.model

    attribute  :id
    attribute  :test_id
    attribute  :status_id
    attribute  :comment
    attribute  :version
    attribute  :elapsed
    attribute  :created_by
    attribute  :created_on
    attribute  :assignedto_id
    attribute  :defects

  end
end
