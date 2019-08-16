# frozen_string_literal: true

require_relative '../lib/block'

RSpec.describe Block do
  let(:block) { described_class.new('a message') }

  describe '#new' do
    it 'sets the message' do
      expect(block.message).to eq 'a message'
    end
  end

  describe '#can_move_on?' do
    subject { block.can_move_on? }
    it { is_expected.to eq true }
  end
end
