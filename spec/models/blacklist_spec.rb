RSpec.describe Blacklist, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:ip) }
  end

  describe 'columns' do
    it { is_expected.to have_db_column(:ip) }
  end
end
