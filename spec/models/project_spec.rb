require 'rails_helper'

describe Project do

  describe "Validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:shortlink) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:keywords) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe "Associations" do
    it { is_expected.to have_many(:screenshots).dependent(:destroy) }
    it { is_expected.to have_and_belong_to_many(:technologies) }
  end

end
