module Admin
  class PagesController < Admin::HomeController
    before_action :set_page, only: %i[show edit update destroy]
    before_action :set_categories, only: %i[new create edit update]

    def index
      @pages = Page.order(:id).includes(:translations)
    end

    def show; end

    def new
      @page = Page.new
    end

    def create
      @page = Page.new(page_params)
      if @page.save
        ::TranslationWorker.perform_async(@page.class, @page.id)
        redirect_to [:admin, @page], notice: "#{t(:page)} #{t(:was_successfully_created)}."
      else
        render 'new'
      end
    end

    def edit; end

    def update
      return add_translate(@page, admin_page_path(@page)) if params[:translation]

      if @page.update(page_params)
        redirect_to [:admin, @page], notice: "#{t(:page)} #{t(:was_successfully_updated)}."
      else
        render 'edit'
      end
    end

    def destroy
      @page.destroy
      redirect_to admin_pages_url, notice: "#{t(:page)} #{t(:was_successfully_destroyed)}."
    end

    private

    def set_page
      @page = Page.find(params[:id])
    end

    def set_categories
      @categories = Category.includes(:translations)
    end

    def page_params
      params.require(:page).permit(:shortlink, :title, :description, :keywords, :content, :position, :category_id,
                                   :publish)
    end
  end
end
