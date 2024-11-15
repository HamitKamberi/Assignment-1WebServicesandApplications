class Api::ProductsController < ApplicationController
  before_action :authorize_request
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /api/products
  def index
    @products = Product.all
    render json: @products
  end

  # GET /api/products/:id
  def show
    render json: @product
  end

  # POST /api/products
  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/products/:id
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/products/:id
  def destroy
    @product.destroy
    head :no_content
  end

  # GET /api/products/search
  def search
    @products = Product.all
  
    # Filter by category (assuming category_id exists)
    if params[:category]
      @products = @products.where(category_id: params[:category])
    end
  
    # Filter by gender (assuming gender is a string, e.g., 'male' or 'female')
    if params[:gender]
      @products = @products.where(gender: params[:gender])
    end
  
    # Filter by brand (assuming brand_id exists)
    if params[:brand]
      @products = @products.where(brand_id: params[:brand])
    end
  
    # Filter by size (assuming size_id exists)
    if params[:size]
      @products = @products.where(size_id: params[:size])
    end
  
    # Filter by color (assuming color_id exists)
    if params[:color]
      @products = @products.where(color_id: params[:color])
    end

    # Filter by minimum price (if price_min is provided)
    if params[:price_min]
      @products = @products.where("price >= ?", params[:price_min])
    end

    # Filter by maximum price (if price_max is provided)
    if params[:price_max]
      @products = @products.where("price <= ?", params[:price_max])
    end
  
    # Ensure that only the above mentioned parameters are allowed.
    render json: @products
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :category, :brand, :size, :color, :gender)
  end
  
end
