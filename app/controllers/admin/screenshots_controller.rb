class Admin::ScreenshotsController < Admin::HomeController
  before_action :set_screenshot, only: [:show, :destroy]

  def create
    @screenshot = Screenshot.new(screenshot_params)

    if @screenshot.save
      render json: { message: 'success', fileID: @screenshot.id }, status: 200
    else
      render json: { error: @screenshot.errors.full_messages.join(',') }, status: 400
    end
  end

  def show
  end

  def destroy
    @screenshot.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: "#{t(:screenshot)} #{t(:was_successfully_destroyed)}." }
      format.json { head :no_content }
      format.js
    end
  end

  private

  def set_screenshot
    @screenshot = Screenshot.find(params[:id])
  end

  def screenshot_params
    params.require(:screenshot).permit(:file, :file_cache, :project_id, :position)
  end
end
