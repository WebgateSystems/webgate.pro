require 'rails_helper'

describe TechnologiesProject do

  describe 'Associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:technology) }
  end

  describe 'Validations' do
    it { is_expected.to validate_uniqueness_of(:technology_id).scoped_to(:project_id) }
  end

end
