require 'rails_helper'

describe Member do

  it 'has a valid factory' do
    expect(build(:member)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:job_title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:motto) }

    it 'validates not publish without avatar' do
      member = Member.new(name: 'test', job_title: 'test', description: 'test', education: 'test',
        publish: true, avatar: nil)
      expect(member.valid?).to be_falsey
      expect(member.errors[:publish].size).to eq(1)
    end
  end

  describe 'Associations' do
    it { is_expected.to have_many(:member_links).dependent(:destroy) }
    it { is_expected.to have_many(:technologies).order('technologies_members.position').through(:technologies_members) }
    it { is_expected.to have_many(:technologies_members) }
  end

  describe 'Method: technology_groups' do
    it 'return member technology groups' do
      member = create(:member)
      tg1 = TechnologyGroup.create!(title: 'Administration')
      tg2 = TechnologyGroup.create!(title: 'Frontend')
      t1 = Technology.create!(title: 'unix', link: 'http://link.com', technology_group: tg1)
      t2 = Technology.create!(title: 'html', link: 'http://link.com', technology_group: tg2)
      member.technologies << [t1, t2]
      expect(member.technology_groups).to match_array([tg1, tg2])
    end

    it 'not return member technology groups' do
      member = create(:member)
      tg1 = TechnologyGroup.create!(title: 'Administration')
      tg2 = TechnologyGroup.create!(title: 'Frontend')
      t1 = Technology.create!(title: 'unix', link: 'http://link.com', technology_group: tg1)
      t2 = Technology.create!(title: 'html', link: 'http://link.com', technology_group: tg2)
      member.technologies << t1
      expect(member.technology_groups).to_not match_array([tg1, tg2])
    end
  end
end
