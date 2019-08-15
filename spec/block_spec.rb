# frozen_string_literal: true

require_relative '../lib/block'

RSpec.describe Block do
  let(:block) { Block.new }

  describe '#can_move_on?' do
    subject { block.can_move_on? }
    it { is_expected.to eq true }
  end
end
