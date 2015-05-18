class ContactsController < ApplicationController
  layout 'portfolio'

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.valid?
        ContactMailer.delay.contact_mail(@contact)
        format.html { redirect_to contact_complete_path, notice: t(:success) }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { redirect_to contact_complete_path, notice: t(:errors) }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content, :nickname)
  end
end
