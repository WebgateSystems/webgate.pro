class Admin::PagesController < Admin::HomeController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :create, :edit, :update]

  def index
    @pages = Page.order(:id).includes(:translations)
  end

  def show
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to [:admin, @page], notice: 'Successfully created admin/page.'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @page.update_attributes(page_params)
      redirect_to [:admin, @page], notice: 'Successfully updated admin/page.'
    else
      render 'edit'
    end
  end

  def destroy
    @page.destroy
    redirect_to admin_pages_url, notice: 'Successfully destroyed admin/page.'
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def set_categories
    @categories = Category.includes(:translations)
  end

  def page_params
    params.require(:page).permit(:shortlink, :title, :description, :keywords, :content, :position, :category_id)
  end

end
