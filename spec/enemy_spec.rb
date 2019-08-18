# frozen_string_literal: true

require_relative '../lib/enemy'

RSpec.describe Enemy do
  let(:enemy) { described_class.new(50) }

  describe 'include Life module' do
    it 'is vulnerable' do
      expect(enemy).to respond_to(:suffered, :dead?)
    end
  end

  describe 'include Move module' do
    it 'can move' do
      expect(enemy).to respond_to(:move, :move_to)
    end
  end

  describe 'include Fight module' do
    it 'can hit' do
      expect(enemy).to respond_to(:hit).with(1).argument
    end
  end
end
