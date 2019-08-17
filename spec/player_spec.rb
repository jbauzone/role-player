# frozen_string_literal: true

require_relative '../lib/player'

RSpec.describe Player do
  let(:player) { described_class.new }

  describe 'include Fight module' do
    it 'can hit' do
      expect(player).to respond_to(:hit).with(1).argument
    end
  end

  describe 'include Move module' do
    it 'can move' do
      expect(player).to respond_to(:move, :move_to)
    end
  end
end
