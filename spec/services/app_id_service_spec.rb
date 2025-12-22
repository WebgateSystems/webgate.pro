# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AppIdService do
  describe '.version' do
    it 'reads first 8 chars from REVISION file when present' do
      revision_file = Rails.root.join('REVISION')
      begin
        File.write(revision_file, "28cad55abcdef\n")
        # Clear memoization
        described_class.instance_variable_set(:@version, nil)

        expect(described_class.version).to eq('28cad55a')
      ensure
        File.delete(revision_file) if File.exist?(revision_file)
        described_class.instance_variable_set(:@version, nil)
      end
    end
  end
end
