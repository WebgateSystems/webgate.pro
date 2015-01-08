# encoding: utf-8
class Admin::CategoriesController < Admin::HomeController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all # todo (order: :position)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.position = Category.count + 1
    if @category.save
      redirect_to [:admin, @category], notice: 'Successfully created admin/category.'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(category_params)
      redirect_to [:admin, @category], notice: 'Successfully updated admin/category.'
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_url, notice: 'Successfully destroyed admin/category.'
  end

  def sort # todo refactoring
    Category.all.each do |category|
      if position = params[:categories].index(category.id.to_s)
        category.update_column(:position, position + 1) unless category.position == position + 1
      end
    end
    render nothing: true, status: 200
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :altlink, :description, :position)
  end

end
