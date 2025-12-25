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

    it 'falls back to git when REVISION file is missing' do
      revision_file = Rails.root.join('REVISION')
      File.delete(revision_file) if File.exist?(revision_file)
      described_class.instance_variable_set(:@version, nil)

      allow(described_class).to receive(:`).with('git rev-parse --short HEAD').and_return("abc12345\n")

      expect(described_class.version).to eq('abc12345')
    ensure
      described_class.instance_variable_set(:@version, nil)
    end
  end
end
