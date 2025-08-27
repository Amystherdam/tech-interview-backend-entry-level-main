require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  before { Sidekiq::Testing.inline! }

  let!(:active_recent_cart) do
    create(:shopping_cart, status: :active, last_interaction_at: 1.hour.ago)
  end

  let!(:active_old_cart) do
    create(:shopping_cart, status: :active, last_interaction_at: 4.hours.ago)
  end

  let!(:abandoned_recent_cart) do
    create(:shopping_cart, status: :abandoned, last_interaction_at: 2.days.ago)
  end

  let!(:abandoned_old_cart) do
    create(:shopping_cart, status: :abandoned, last_interaction_at: 8.days.ago)
  end

  describe "#perform" do
    it "does not mark recently active carts as abandoned" do
      expect {
        described_class.new.perform
      }.not_to change { active_recent_cart.reload.status }
    end

    it "Marks active carts with no interaction for more than 3 hours as abandoned" do
      expect {
        described_class.new.perform
      }.to change { active_old_cart.reload.status }.from("active").to("abandoned")
    end

    it "does not remove carts abandoned less than 7 days ago" do
      expect {
        described_class.new.perform
      }.not_to change { Cart.exists?(abandoned_recent_cart.id) }
    end

    it "removes carts abandoned for more than 7 days" do
      expect {
        described_class.new.perform
      }.to change { Cart.exists?(abandoned_old_cart.id) }.from(true).to(false)
    end
  end
end
