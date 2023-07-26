class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :js_request?

  def not_found
    respond_to do |format|
      format.html { render status: :not_found }
      format.all  { render text: t('error_404'), status: :not_found }
    end
  end

  def server_error
    render status: :ok, formats: [:html]
  end

  def wrong_params
    render status: :ok, formats: [:html]
  end

  protected

  def js_request?
    request.format.js?
  end
end
