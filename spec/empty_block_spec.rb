# frozen_string_literal: true

require_relative '../lib/empty_block'

RSpec.describe EmptyBlock do
  let(:empty_block) { EmptyBlock.new }

  describe '#can_move_on?' do
    subject { empty_block.can_move_on? }
    it { is_expected.to eq false }
  end
end
