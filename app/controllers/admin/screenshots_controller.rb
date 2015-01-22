class Admin::ScreenshotsController < Admin::HomeController

  def create
    @screenshot = Screenshot.new(screenshot_params)

    if @screenshot.save
      render json: { message: 'success', fileID: @screenshot.id }, status: 200
    else
      render json: { error: @screenshot.errors.full_messages.join(',')}, status: 400
    end 
  end

  private
  
  def screenshot_params
    params.require(:screenshot).permit(:file, :project_id, :position)
  end

end
