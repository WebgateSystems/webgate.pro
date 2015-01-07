class Admin::PagesController < Admin::HomeController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = Page.order(:id)
  end

  def show
  end

  def new
    @page = Page.new
    @page.content = ""
    @categories = Category.select_all
    #@subcategories = Subcategory.select_all
  end

  def create
    @categories = Category.select_all
    #@subcategories = Subcategory.select_all
    @page = Page.new(page_params)
    @page.position = Page.count + 1
    if @page.save
      redirect_to [:admin, @page], notice: 'Successfully created admin/page.'
    else
      render 'new'
    end
  end

  def edit
    @categories = Category.select_all
    #@subcategories = Subcategory.select_all
  end

  def update
    @categories = Category.select_all
    #@subcategories = Subcategory.select_all
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

  def page_params
    params.require(:page).permit(:shortlink, :title, :description, :keywords, :content, :position)
  end

end
