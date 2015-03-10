require 'rails_helper'

describe Member do

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:shortdesc) }
    it { is_expected.to validate_presence_of(:motto) }
  end

  describe "Associations" do
    it { is_expected.to have_many(:member_links).dependent(:destroy) }
    it { is_expected.to have_and_belong_to_many(:technologies) }
  end

end
