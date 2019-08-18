# frozen_string_literal: true

require_relative '../lib/player'

RSpec.describe Player do
  let(:player) { described_class.new(100) }

  describe 'include Life module' do
    it 'is vulnerable' do
      expect(player).to respond_to(:suffered, :dead?)
    end
  end

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
