class ContactsController < ApplicationController
  layout 'portfolio'

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.valid?
        SupportMailer.delay.contact_support(@contact)
        format.html { redirect_to contact_complete_path, notice: 'success' }
        format.json { render json: @contact }
        #format.js   { render js: "window.location.pathname = #{contact_complete_path.to_json}" }
      else
        format.html { redirect_to contact_complete_path, notice: 'errors' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
        #format.js   { render js: "window.location.pathname = #{contact_complete_path.to_json}" }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content, :nickname)
  end
end
