require 'rails_helper'

describe Page do
  it 'has a valid PL factory' do
    expect(build(:pl_page)).to be_valid
  end

  it 'has a valid EN factory' do
    expect(build(:en_page)).to be_valid
  end

  it 'has a valid RU factory' do
    expect(build(:ru_page)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:shortlink) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:keywords) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_uniqueness_of(:shortlink).case_insensitive }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:category) }
  end
end
