module TestRail
  class CaseType
    include Virtus.model
    include InitializeWithApi

    attribute :id
    attribute :name
    attribute :is_default

  end
end
