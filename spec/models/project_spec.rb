require 'rails_helper'

describe Project do
  it 'has a valid factory' do
    expect(build(:project)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:livelink) }
    it { is_expected.to allow_value('https://webgate.pro').for(:livelink) }
    it { is_expected.to allow_value('http://webgate.pro').for(:livelink) }
    it { is_expected.to_not allow_value('webgate.pro').for(:livelink) }
    it { is_expected.to_not allow_value('://webgate.pro').for(:livelink) }

    it 'validates not publish without collage' do
      project = described_class.new(title: 'test', content: 'test', livelink: 'https://test.com',
                                    publish: true, collage: nil)
      expect(project.valid?).to be_falsey
      expect(project.errors[:publish].size).to eq(1)
    end
  end

  describe 'Associations' do
    it { is_expected.to have_many(:screenshots).dependent(:destroy) }
    it { is_expected.to have_many(:technologies).order('technologies_projects.position').through(:technologies_projects) }
    it { is_expected.to have_many(:technologies_projects) }
  end
end
