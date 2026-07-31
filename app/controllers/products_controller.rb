class ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]

  # GET /products?page=1&per=20&name=xxx&category=xxx&status=0
  def index
    products = Product.all

    products = products.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    products = products.where(category: params[:category]) if params[:category].present?
    products = products.where(status: params[:status]) if params[:status].present?

    products = products.order(created_at: :desc).page(params[:page]).per(params[:per] || 20)

    render json: {
      data: products,
      meta: {
        current_page: products.current_page,
        total_pages: products.total_pages,
        total_count: products.total_count,
        per_page: products.limit_value
      }
    }
  end

  # GET /products/:id
  def show
    render json: { data: @product }
  end

  # POST /products
  def create
    product = Product.new(product_params)
    if product.save
      render json: { data: product }, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/:id
  def update
    if @product.update(product_params)
      render json: { data: @product }
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /products/:id
  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
    render json: { errors: ["产品不存在"] }, status: :not_found unless @product
  end

  def product_params
    params.require(:product).permit(:name, :category, :price, :status)
  end
end
