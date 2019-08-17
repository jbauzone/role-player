# frozen_string_literal: true

require_relative '../lib/enemy'

RSpec.describe Enemy do
  let(:enemy) { described_class.new(50) }

  describe 'include Life module' do
    it 'is vulnerable' do
      expect(enemy).to respond_to(:suffered, :dead?)
    end
  end
end
