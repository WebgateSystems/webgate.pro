require 'rails_helper'

describe TechnologyGroup do
  it 'has a valid factory' do
    expect(build(:technology_group)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:technologies) }
  end
end
