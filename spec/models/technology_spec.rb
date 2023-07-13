describe Technology, type: :model do
  it 'has a valid factory' do
    expect(build(:technology)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    # it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:technology_group) }
    it { is_expected.to have_many(:projects).through(:technologies_projects) }
    it { is_expected.to have_many(:technologies_projects) }
    it { is_expected.to have_many(:members).through(:technologies_members) }
    it { is_expected.to have_many(:technologies_members) }
  end
end
