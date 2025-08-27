# app/serializers/cart_serializer.rb
class CartSerializer
  attr_reader :cart, :cart_items

  def initialize(cart)
    @cart = cart
    @cart_items = cart.cart_items.includes(:product)
  end

  def as_json(*)
    {
      id: cart.id,
      products: cart_products,
      total_price: total_price
    }
  end

  private

  def cart_products
    cart_items.map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.product.price.to_f,
        total_price: (item.quantity * item.product.price).to_f
      }
    end
  end

  def total_price
    cart_items.sum { |item| item.quantity * item.product.price }.to_f
  end
end
