require 'rails_helper'

describe Technology do
  it 'has a valid factory' do
    expect(build(:technology)).to be_valid
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:technology_group) }
  end
end
