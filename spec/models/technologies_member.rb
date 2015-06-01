require 'rails_helper'

describe TechnologiesMember do

  describe 'Associations' do
    it { is_expected.to belong_to(:member) }
    it { is_expected.to belong_to(:technology) }
  end

  describe 'Validations' do
    it { is_expected.to validate_uniqueness_of(:technology_id).scoped_to(:member_id) }
  end

end
