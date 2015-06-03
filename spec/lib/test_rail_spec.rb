require "spec_helper"
require "faker"

describe TestRail do

  before(:each) do
    TestRail.configuration = nil
    TestRail.api = nil
  end

  let(:user) { "#{Faker::Name.first_name}_#{Faker::Name.last_name}".downcase }
  let(:password) { Faker::Internet.password }
  let(:namespace) { Faker::Internet.domain_word }

  describe ".configure" do

    before(:each) do
      TestRail.configure do |config|
        config.user      = user
        config.password  = password
        config.namespace = namespace
      end
    end

    subject { TestRail.configuration }

    its(:user) { should eq user }
    its(:password) { should eq password }
    its(:namespace) { should eq namespace }
  end

  describe ".method_missing" do

    context "when no configuration block has been provided" do

      it "raises an exception" do
        expect { TestRail.foo }.to raise_error(TestRail::NO_CONFIG_ERROR)
      end
    end

    context "configuration block has been provided" do

      let(:api_instance) { double(TestRail::API, foo: :foo_return, bar: :bar_return) }

      before(:each) do
        TestRail::API.stub(new: api_instance)
        TestRail.configure do |config|
          config.user      = user
          config.password  = password
          config.namespace = namespace
        end
      end

      let(:foo_args) { { arg: :value } }
      let(:foo_block) { lambda { puts "Some Block" } }

      let!(:foo_value) { TestRail.foo(foo_args, &foo_block) }
      let!(:bar_value) { TestRail.bar}


      it "delegates calls to an API instance, passing on any arguments or blocks" do
        expect(api_instance).to have_received(:foo).with(foo_args, &foo_block)
      end

      it "returns the value from the delegated call" do
        expect(foo_value).to eq :foo_return
      end

      it "returns the value from the delegated call" do
        expect(bar_value).to eq :bar_return
      end

      it "delegates the subsequent calls to the same API instance" do
        expect(api_instance).to have_received(:bar)
      end

      it "only instantiated an api once with the username, password and namespace" do
        expect(TestRail::API).to have_received(:new).with(user: user, password: password, namespace: namespace).once
      end
    end
  end
end
