module Admin
  class CategoriesController < Admin::HomeController
    before_action :set_category, only: %i[show edit update destroy]

    def index
      @categories = Category.rank(:position).includes(:translations, page: :translations)
    end

    def show; end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        ::TranslationWorker.perform_async(@category.class, @category.id, cookies[:lang])
        redirect_to [:admin, @category], notice: "#{t(:category)} #{t(:was_successfully_created)}."
      else
        render 'new'
      end
    end

    def edit; end

    def update
      return add_translate(@category, admin_category_path(@category)) if params[:translation]

      if @category.update(category_params)
        redirect_to [:admin, @category], notice: "#{t(:category)} #{t(:was_successfully_updated)}."
      else
        render 'edit'
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_url, notice: "#{t(:category)} #{t(:was_successfully_destroyed)}."
    end

    def update_position
      @category = Category.find(category_params[:category_id])
      @category.position_position = category_params[:row_position]
      respond_to do |format|
        @category.save! ? format.json { head :ok } : format.json { head :error }
        format.html
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
end
