module TestRail

  class Configuration
    attr_accessor :user, :password, :namespace

    def to_hash
      { user: user, password: password, namespace: namespace }
    end
  end
end
