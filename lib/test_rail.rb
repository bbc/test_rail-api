$: << File.dirname(__FILE__)
require 'net/http'
require 'net/https'
require 'json'
require "virtus"
require "test_rail/configuration"
require "test_rail/api"
require "test_rail/initialize_with_api"
require 'test_rail/project'
require 'test_rail/section'
require 'test_rail/suite'
require 'test_rail/test_case'
require 'test_rail/plan'
require 'test_rail/run'
require 'test_rail/test'
require 'test_rail/case_type'
require 'test_rail/priority'

module TestRail

  NO_CONFIG_ERROR = <<eos
      A configuration block must first be provided.
      e.g:
      TestRail.configure do |config|
        config.user      = "user"
        config.password  = "password"
        config.namespace = "namespace"
      end
eos

  class << self
    attr_accessor :configuration, :api

    def configure
      self.configuration = Configuration.new
      yield(configuration)
    end

    def method_missing(method, *args, &block)
      raise TestRail::NO_CONFIG_ERROR if configuration.nil?
      api.send(method, *args, &block)
    end

    private

    def api
      @api ||= TestRail::API.new(configuration.to_hash)
    end
  end
end
