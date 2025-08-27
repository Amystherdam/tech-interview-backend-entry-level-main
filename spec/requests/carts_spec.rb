require 'rails_helper'

RSpec.describe "/carts", type: :request do
  let(:product) { create(:product) }

  before do
    get '/cart'
  end

  describe "POST /cart" do
    subject do
      post '/cart', params: { cart: { product_id: product.id, quantity: 2 } }, as: :json
    end

    context "when the item is successfully added" do
      it "creates a cart item and returns the serialized cart" do
        expect { subject }.to change { CartItem.count }.by(1)
        subject
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json["id"]).to eq(session[:cart_id])
        expect(json["products"].first["id"]).to eq(product.id)
        expect(json["products"].first["quantity"]).to eq(2)
      end
    end

    context "when validation fails" do
      it "returns unprocessable_entity with errors" do
        create(:cart_item, cart_id: session[:cart_id], product_id: product.id)
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json).to eq(["Product Item is already in cart"])
      end
    end
  end

  describe "POST /add_items" do
    let(:cart_item) { create(:cart_item, cart_id: session[:cart_id], product_id: product.id) }
    
    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_items', params: { cart: { product_id: product.id, quantity: 1 } }, as: :json
        post '/cart/add_items', params: { cart: { product_id: product.id, quantity: 1 } }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
end
