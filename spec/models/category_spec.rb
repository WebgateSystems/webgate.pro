require 'rails_helper'

describe Category do

  it 'has a valid PL factory' do
    expect(build(:pl_category)).to be_valid
  end

  it 'has a valid EN factory' do
    expect(build(:category)).to be_valid
  end

  it 'has a valid RU factory' do
    expect(build(:ru_category)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:altlink) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'Associations' do
    it { is_expected.to have_one(:page) }
  end

end
