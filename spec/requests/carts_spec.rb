require 'rails_helper'

RSpec.describe "/carts", type: :request do
  let(:product) { create(:product) }

  before do
    get '/cart'
  end

  describe "GET /cart" do
    context "when the cart is empty" do
      it "returns an empty cart with total_price 0" do
        get '/cart'
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json["id"]).to eq(session[:cart_id])
        expect(json["products"]).to eq([])
        expect(json["total_price"]).to eq(0.0)
      end
    end

    context "when the cart has items" do
      let!(:cart_item) { create(:cart_item, cart_id: session[:cart_id], product: product, quantity: 3) }

      it "returns the serialized cart with products" do
        get '/cart'
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json["id"]).to eq(session[:cart_id])
        expect(json["products"].size).to eq(1)

        product_json = json["products"].first
        expect(product_json["id"]).to eq(product.id)
        expect(product_json["name"]).to eq(product.name)
        expect(product_json["quantity"]).to eq(cart_item.quantity)
        expect(product_json["unit_price"]).to eq(product.price.to_f)
        expect(product_json["total_price"]).to eq((cart_item.quantity * product.price).to_f)

        expect(json["total_price"]).to eq((cart_item.quantity * product.price).to_f)
      end
    end
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

  describe "DELETE /cart/:product_id" do
    let!(:cart_item) { create(:cart_item, cart_id: session[:cart_id], product: product, quantity: 2) }

    context "when the product exists in the cart" do
      it "removes the item and returns the updated cart" do
        expect {
          delete "/cart/#{product.id}"
        }.to change { CartItem.count }.by(-1)

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq(session[:cart_id])
        expect(json["products"]).to eq([])
        expect(json["total_price"]).to eq(0.0)
      end
    end

    context "when the product does not exist in the cart" do
      it "returns ok with 'Product not found' message" do
        delete "/cart/0"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Product not found")
      end
    end
  end

end
