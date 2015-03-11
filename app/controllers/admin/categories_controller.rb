# encoding: utf-8
class Admin::CategoriesController < Admin::HomeController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.rank(:position).all
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
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

  def update_position
    @category = Category.find(category_params[:category_id])
    @category.position_position = category_params[:row_position]
    respond_to do |format|
      if @category.save!
        format.json { head :ok }
      else
        format.json { head :error }
      end
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:category_id, :row_position, :name, :altlink, :description)
  end

end
