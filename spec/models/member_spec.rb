require 'rails_helper'

describe Member do

  describe "Validations" do
    it { expect validate_presence_of(:name) }
    it { expect validate_presence_of(:description) }
    it { expect validate_presence_of(:shortdesc) }
    it { expect validate_presence_of(:motto) }
  end

  describe "Associations" do
    it { expect have_many(:member_links).dependent(:destroy) }
    it { expect have_and_belong_to_many(:technologies) }
  end

end
