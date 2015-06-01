require 'rails_helper'

describe User do
  it 'has a valid PL factory' do
    expect(build(:user)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to allow_value('test@webgate.pro').for(:email) }
    it { is_expected.to_not allow_value('test@webgate').for(:email) }
    it { is_expected.to_not allow_value('@webgate.pro').for(:email) }
    it { is_expected.to_not allow_value('webgate.pro').for(:email) }
  end
end
