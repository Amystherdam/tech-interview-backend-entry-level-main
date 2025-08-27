class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :product_id, uniqueness: { scope: :cart_id, message: "Item is already in cart" }

  def increment_quantity(by:)
    self.quantity = (quantity || 0) + by.to_i
  end
end
