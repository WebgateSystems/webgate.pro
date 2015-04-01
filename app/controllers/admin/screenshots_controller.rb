class Admin::ScreenshotsController < Admin::HomeController
  before_action :set_screenshot, only: [:destroy]

  def create
    @screenshot = Screenshot.new(screenshot_params)

    if @screenshot.save
      render json: { message: 'success', fileID: @screenshot.id }, status: 200
    else
      render json: { error: @screenshot.errors.full_messages.join(',')}, status: 400
    end
  end

  def destroy
    @screenshot.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Successfully destroyed screenshot.' }
      format.json { head :no_content }
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
