class ContactsController < ApplicationController
  layout 'portfolio'

  # def new
  #   @contact = Contact.new
  # end

  def create
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.valid?
        ContactMailer.contact_mail(@contact.email, @contact.name, @contact.nickname).deliver_later!
        format.json { render json: @contact, status: :created, location: @contact }
        format.html { redirect_to contact_complete_path, notice: t(:success) }
      else
        format.json { render json: @contact.errors, status: :unprocessable_entity }
        format.html { redirect_to contact_complete_path, notice: t(:errors) }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content, :nickname)
  end
end
