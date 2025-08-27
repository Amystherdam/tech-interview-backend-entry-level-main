class MarkCartAsAbandonedJob
  include Sidekiq::Job
  queue_as :default

  def perform
    mark_as_abandoned
    remove_abandoned
  end

  private

  def mark_as_abandoned
    Cart.active.where("last_interaction_at <= ?", 3.hours.ago).find_each do |cart|
      cart.mark_as_abandoned
    end
  end

  def remove_abandoned
    Cart.abandoned.where("last_interaction_at <= ?", 7.days.ago).find_each do |cart|
      cart.remove_if_abandoned
    end
  end
end
