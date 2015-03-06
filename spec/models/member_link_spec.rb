require 'rails_helper'

describe MemberLink do

  it 'has a valid factory' do
    expect(build(:member_link)).to be_valid
  end

  it { expect validate_presence_of :name }
  it { expect validate_presence_of :link }

  it { expect belong_to(:member) }

end
