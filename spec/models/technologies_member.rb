require 'rails_helper'

describe TechnologiesMember do

  describe "Associations" do
    it { is_expected.to belong_to(:member) }
    it { is_expected.to belong_to(:technology) }
  end

end
