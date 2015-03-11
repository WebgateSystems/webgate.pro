require 'rails_helper'

describe Screenshot do

  it 'has a valid factory' do
    expect(build(:screenshot)).to be_valid
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:file) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:project) }
  end

end
