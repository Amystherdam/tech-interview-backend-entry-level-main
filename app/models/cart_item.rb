class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  def increment_quantity(by:)
    self.quantity = (quantity || 0) + by.to_i
  end
end
