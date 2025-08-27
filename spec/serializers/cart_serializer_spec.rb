require 'rails_helper'

RSpec.describe CartSerializer do
  describe '#as_json' do
    let(:cart) { create(:shopping_cart) }

    let!(:product1) { create(:product, name: "Product 1", price: 10.5) }
    let!(:product2) { create(:product, name: "Product 2", price: 5.25) }

    let!(:cart_item1) { create(:cart_item, cart: cart, product: product1, quantity: 2) }
    let!(:cart_item2) { create(:cart_item, cart: cart, product: product2, quantity: 3) }

    subject(:serialized) { described_class.new(cart).as_json }

    it 'includes the cart id' do
      expect(serialized[:id]).to eq(cart.id)
    end

    it 'returns the products with correct attributes' do
      expect(serialized[:products]).to match_array([
        {
          id: product1.id,
          name: product1.name,
          quantity: cart_item1.quantity,
          unit_price: product1.price,
          total_price: (cart_item1.quantity * cart_item1.product.price).to_f
        },
        {
          id: product2.id,
          name: product2.name,
          quantity: cart_item2.quantity,
          unit_price: product2.price,
          total_price: (cart_item2.quantity * cart_item2.product.price).to_f
        }
      ])
    end

    it 'calculates the total price of the cart correctly' do
      expect(serialized[:total_price]).to eq(cart.cart_items.sum { |item| item.quantity * item.product.price }.to_f)
    end
  end
end
