require 'rails_helper'

describe TechnologiesProject do

  describe "Associations" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:technology) }
  end

end
