# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BaseInteractor do
  subject(:interactor) { TestInteractor.new }

  before do
    stub_const('TestInteractor', Class.new(BaseInteractor) do
      def call; end

      def normalize(answer)
        send(:normalize_answer_hash, answer)
      end

      def stringify(obj)
        send(:deep_stringify_keys, obj)
      end
    end)
  end

  describe '#deep_stringify_keys' do
    it 'stringifies hash keys recursively and handles arrays' do
      input = { a: 1, 'b' => [{ c: 2 }, 3] }
      expect(interactor.stringify(input)).to eq({ 'a' => 1, 'b' => [{ 'c' => 2 }, 3] })
    end
  end

  describe '#normalize_answer_hash' do
    it 'accepts objects responding to to_h' do
      obj = Class.new do
        def to_h = { a: { b: 1 } }
      end.new
      expect(interactor.normalize(obj)).to eq({ 'a' => { 'b' => 1 } })
    end
  end
end
