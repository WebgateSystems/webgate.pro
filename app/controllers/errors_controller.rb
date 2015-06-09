class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :js_request?

  def not_found
    respond_to do |format|
      format.html { render status: 404 }
      format.all  { render text: t(:error_404), status: 404 }
    end
  end

  protected

  def js_request?
    request.format.js?
  end
end
