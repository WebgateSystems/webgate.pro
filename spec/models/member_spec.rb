require 'rails_helper'

describe Member do
  before do
    @member = FactoryGirl.create(:member)
  end

  describe "when name is not present" do
    before { @member.name = " "}
    it {should_not be_valid}
  end

  describe "when short description is not present" do
    before { @member.shortdesc = " "}
    it {should_not be_valid}
  end

  describe "when description is not present" do
    before { @member.name = " "}
    it {should_not be_valid}
  end

  describe "when motto is not present" do
    before { @member.name = " "}
    it {should_not be_valid}
  end
end