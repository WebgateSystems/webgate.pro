require 'rails_helper'

describe Page do

  it 'has a valid factory' do
    expect(build(:en_page)).to be_valid
  end

  describe 'Validations' do
    let!(:page1) { create(:en_page) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:shortlink) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:keywords) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_uniqueness_of(:shortlink).case_insensitive }
    it 'has a unique shortlink on other locales with insensitive' do
      I18n.locale = 'ru'
      page2 = build(:en_page, shortlink: page1.shortlink.upcase)
      page2.valid?
      expect(page2.errors[:shortlink].size).to eq(1)
      I18n.locale = 'en'
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:category) }
  end
end
