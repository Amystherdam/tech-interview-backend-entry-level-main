class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  after_commit :update_cart_interaction, :recovery_cart, on: %i[create update destroy]

  validates :product_id, uniqueness: { scope: :cart_id, message: "Item is already in cart" }

  def increment_quantity(by:)
    self.quantity = (quantity || 0) + by.to_i
  end

  private

    def update_cart_interaction
      cart.update(last_interaction_at: Time.current)
    end

    def recovery_cart
      return if cart.active?

      cart.update(status: :active)
    end
end
