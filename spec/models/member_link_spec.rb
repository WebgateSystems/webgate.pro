require 'rails_helper'

describe MemberLink do
  it 'has a valid factory' do
    expect(build(:member_link)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :link }
    it { is_expected.to allow_value('https://webgate.pro').for(:link) }
    it { is_expected.to allow_value('http://webgate.pro').for(:link) }
    it { is_expected.to_not allow_value('webgate.pro').for(:link) }
    it { is_expected.to_not allow_value('://webgate.pro').for(:link) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:member) }
  end
end
