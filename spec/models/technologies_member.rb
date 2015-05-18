require 'rails_helper'

describe TechnologiesMember do

  it 'has a valid factory' do
    #expect(build(:member)).to be_valid
  end

  describe "Validations" do
  end

  describe "Associations" do
    it { is_expected.to belong_to(:member) }
    #it { is_expected.to belong_to(:project) }
  end

end
