require 'rails_helper'

describe Project do

  it 'has a valid factory' do
    expect(build(:project)).to be_valid
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:shortlink) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:keywords) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:livelink) }
    it { is_expected.to allow_value('https://webgate.pro').for(:livelink) }
    it { is_expected.to allow_value('http://webgate.pro').for(:livelink) }
    it { is_expected.to_not allow_value('webgate.pro').for(:livelink) }
    it { is_expected.to_not allow_value('://webgate.pro').for(:livelink) }
  end

  describe "Associations" do
    it { is_expected.to have_many(:screenshots).dependent(:destroy) }
    it { is_expected.to have_and_belong_to_many(:technologies) }
  end

end
