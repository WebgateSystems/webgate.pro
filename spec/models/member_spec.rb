require 'rails_helper'

describe Member do

  it 'has a valid factory' do
    expect(build(:member)).to be_valid
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:shortdesc) }
    it { is_expected.to validate_presence_of(:motto) }
    it { is_expected.to validate_presence_of(:avatar) }
  end

  describe "Associations" do
    it { is_expected.to have_many(:member_links).dependent(:destroy) }
    it { is_expected.to have_and_belong_to_many(:technologies) }
  end

end
