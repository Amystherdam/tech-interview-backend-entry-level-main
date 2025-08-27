class Cart < ApplicationRecord
  enum status: { active: 0, abandoned: 1 }

  has_many :cart_items, dependent: :destroy

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  def mark_as_abandoned
    update(status: :abandoned)
  end

  def remove_if_abandoned
    destroy!
  end
end
