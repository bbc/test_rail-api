test_rail
=========

Ruby Client for v2 TestRail API

This library aims to provide two things:

1. A simple one-to-one mapping of the testrail api
2. A ruby-like abstraction to help deal with the various
   testrail objects

Usage
=====

There are two primary methods of use, you can either create your own API instance object and make calls through that or
otherwise provide a config block and have a shared API instance and call methods directly on TestRail.

Unique API Instance
-------------------

The main entry point to the object is TestRail::API. To create
the api object do:

    tr = TestRail::API.new( :user      => 'someone@example.com',
                            :password  => 'passw0rd',
                            :namespace => 'mytestrailinstance' )

Usually you have to interact with testrail with specific project
ids, but we have privided a number of helpful find methods
that make testrail interaction a lot easier:

    project = tr.find_project(:name => test_rail_project)

From the project, you can get to your test_suites, runs or plans.
We also manage section hierarchies for you so you can call
successive sections and testsuites.

Shared API instance
-----------------------

An alternative method is to provide a config block, this specifies a default set of configuration options that will be
used to connect to a test rail instance. The first time a call is made directly on the ```TestRail``` namespace an API object
 will be instantiated with those config options and used for that and subsequent calls.

1. Provide a config block.
```ruby
  TestRail.configure do |config|
    config.user      = ENV['TEST_RAIL_USER']
    config.password  = ENV['TEST_RAIL_PASSWORD']
    config.namespace = ENV['TEST_RAIL_NAMESPACE']
  end
```

2. use the API via the TestRail object directly as you would via a standard ```TestRail::API object```
```ruby
  TestRail.get_plan(plan_id: 1) => TestRail::Plan
```

TESTING
=======

Tests are mostly at the integration level, and require a testrail 
instance to exercise the functions.

    bundle
    bundle exec rspec
