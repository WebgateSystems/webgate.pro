require 'rails_helper'

describe LinkTranslation do

  it 'has a valid factory' do
    expect(build(:link_translation)).to be_valid
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:link) }
    it { is_expected.to validate_presence_of(:locale) }
    it { is_expected.to validate_presence_of(:link_type) }
  end

end
