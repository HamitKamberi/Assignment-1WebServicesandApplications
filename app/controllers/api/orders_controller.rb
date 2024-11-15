class Api::OrdersController < ApplicationController
  before_action :authorize_request
  before_action :set_order, only: [:show, :update]

  # GET /api/orders
  def index
    @orders = Order.all
    render json: @orders
  end

  # GET /api/orders/:id
  def show
    render json: @order
  end

  # POST /api/orders
  def create
    @order = Order.new(order_params)
    @order.client_id = current_user.id # Automatically associate the order with the current user
    if @order.save
      # Update product stock based on order quantity
      @order.order_items.each do |item|
        product = Product.find(item.product_id)
        product.update(stock: product.stock - item.quantity)
      end
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/orders/:id
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :client_id, order_items_attributes: [:product_id, :quantity])
  end
end
