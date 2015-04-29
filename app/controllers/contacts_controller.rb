class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.valid?
        SupportMailer.delay.contact_support(@contact)
        format.html { render partial: 'contact_complete' }
        format.json { render head :no_content }
        format.js
      else
        format.html { render partial: 'contact_complete' }
        format.json { render head :no_content }
        format.js
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content, :nickname)
  end
end
