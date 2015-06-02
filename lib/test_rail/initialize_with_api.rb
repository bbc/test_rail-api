module TestRail
  module InitializeWithApi

    # Takes params and assigns the provided api then uses the inherited (usually Virtus) initializer
    def initialize(params)
      @api = params[:api]
      super params
    end
  end
end
