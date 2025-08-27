class Cart < ApplicationRecord
  enum status: { active: 0, abandoned: 1 }

  validates :total_price, numericality: { only_numeric: true, greater_than_or_equal_to: 0 }

  def mark_as_abandoned
    update(status: :abandoned)
  end

  def remove_if_abandoned
    destroy
  end
end
