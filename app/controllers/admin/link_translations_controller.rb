class Admin::LinkTranslationsController < Admin::HomeController
  before_action :set_link_translation, only: [:show, :edit, :update, :destroy]

  def index
    @link_translations = LinkTranslation.all
  end

  def show
  end

  def new
    @link_translation = LinkTranslation.new
  end

  def create
    @link_translation = LinkTranslation.new(link_translation_params)
    if @link_translation.save
      redirect_to [:admin, @link_translation], notice: "#{t(:link_translation)} #{t(:was_successfully_created)}."
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @link_translation.update_attributes(link_translation_params)
      redirect_to [:admin, @link_translation], notice: "#{t(:link_translation)} #{t(:was_successfully_updated)}."
    else
      render 'edit'
    end
  end

  def destroy
    @link_translation.destroy
    redirect_to admin_link_translations_url, notice: "#{t(:link_translation)} #{t(:was_successfully_destroyed)}."
  end

  private

  def set_link_translation
    @link_translation = LinkTranslation.find(params[:id])
  end

  def link_translation_params
    params.require(:link_translation).permit(:link, :locale, :link_type)
  end

end
