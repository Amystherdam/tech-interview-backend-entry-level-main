class CartsController < ApplicationController
  before_action :set_cart, only: %i[ show create add_items remove_item ]

  # GET /cart
  def show
    render json: CartSerializer.new(@cart).as_json, status: :ok
  end

  # POST /cart
  def create
    cart_item = CartItem.new(cart_item_params.merge(cart_id: session[:cart_id]))

    if cart_item.save
      render json: CartSerializer.new(@cart).as_json, status: :created
    else
      render json: cart_item.errors.full_messages, status: :unprocessable_entity
    end
  end

  # POST /cart/add_items
  def add_items
    cart_item = CartItem.find_by(
      cart_id: session[:cart_id],
      product_id: cart_item_params[:product_id]
    )

    unless cart_item
      render json: 'Just adding items', status: :ok
      return
    end

    cart_item.quantity = cart_item_params[:quantity]

    if cart_item.save
      render json: CartSerializer.new(@cart).as_json, status: :created
    else
      render json: cart_item.errors, status: :unprocessable_entity
    end
  end 

  # DELETE /cart/:product_id
  def remove_item
    cart_item = @cart.cart_items.find_by(product_id: params[:product_id].to_i)

    unless cart_item
      render json: 'Product not found', status: :ok
      return
    end

    if cart_item.destroy
      render json: CartSerializer.new(@cart).as_json, status: :ok
    end
  end

  private
    def set_cart
      @cart = Cart.find_by(id: session[:cart_id]) || Cart.create(total_price: 0, last_interaction_at: DateTime.now)
      session[:cart_id] = @cart.id
    end

    def cart_item_params
      params.require(:cart).permit(:product_id, :quantity)
    end
end
