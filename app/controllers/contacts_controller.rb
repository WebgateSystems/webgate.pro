class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.valid? && @contact.nickname == ''
      SupportMailer.delay.contact_support(@contact)
      redirect_to :back, notice: t('thank_you_for_your_message') #todo
    else
      redirect_to :back
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content, :nickname)
  end
end
