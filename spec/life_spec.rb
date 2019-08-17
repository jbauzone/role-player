# frozen_string_literal: true

require_relative '../lib/life'

RSpec.describe Life do
  let(:fake_enemy_class) do
    class FakeEnemy
      include Life
    end
  end
  let(:enemy) { fake_enemy_class.new(life) }

  describe '#new' do
    context 'when life is positive' do
      let(:life) { 75 }
      it 'sets the life' do
        expect(enemy.life).to eq life
      end
    end

    context 'when life is negative' do
      let(:life) { -50 }

      it 'raises an ArgumentError' do
        expect { enemy }.to raise_error(ArgumentError)
      end
    end

    context 'when life is 0' do
      let(:life) { 0 }

      it 'raises an ArgumentError' do
        expect { enemy }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#suffered' do
    let(:damage) { 30 }
    subject { enemy.suffered(damage) }

    context 'damage infliged are greater than current life' do
      let(:life) { 20 }

      it 'goes down life to 0' do
        expect { subject }.to change { enemy.life }.from(life).to(0)
      end

      it 'calls on_damage_infliged callback' do
        expect(enemy).to receive(:on_damage_infliged)
        subject
      end
    end

    context 'damage infliged are lower than current life' do
      let(:life) { 50 }

      it 'goes down life to 20' do
        expect { subject }.to change { enemy.life }.from(life).to(20)
      end

      it 'calls on_damage_infliged callback' do
        expect(enemy).to receive(:on_damage_infliged)
        subject
      end
    end
  end

  describe '#dead?' do
    subject { enemy.dead? }

    context 'when enemy has 0 life' do
      let(:life) { 10 }
      before 'enemy is hit' do
        enemy.suffered(life)
      end

      it { is_expected.to eq true }
    end

    context 'when enemy has life' do
      let(:life) { 50 }
      it { is_expected.to eq false }
    end
  end
end
