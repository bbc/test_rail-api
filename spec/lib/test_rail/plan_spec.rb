require "spec_helper"
require "faker"

module TestRail
  describe Plan do

    describe "class methods" do

      before(:each) do
        TestRail.stub(get_plan: :plan)
      end

      describe ".find_by_id" do

        let(:plan_id) { Faker::Number.number(3) }

        subject! { TestRail::Plan.find_by_id(plan_id) }

        it { should eq :plan }

        it "delegated to TestRail#get_plan passing the plan_id in a hash of options" do
          expect(TestRail).to have_received(:get_plan).with(plan_id: plan_id)
        end
      end
    end
  end
end
