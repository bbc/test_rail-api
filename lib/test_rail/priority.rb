module TestRail
  class Priority
    include Virtus.model
    include InitializeWithApi

    attribute :id
    attribute :name
    attribute :is_default
    attribute :short_name
    attribute :priority

  end
end
