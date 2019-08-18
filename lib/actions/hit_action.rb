# frozen_string_literal: true

require_relative 'base_action'

module Actions
  # Represents the class to perform hit action.
  class HitAction < BaseAction
    def initialize(game, player, enemy)
      super(game)
      @player = player
      @enemy = enemy
    end

    def do
      if @player.current_available_actions&.include?(Action::HIT)
        @player.hit(@enemy)

        if @enemy.dead?
          @game.stop(GameStatus::WON)
        else
          @game.display("** You hit the enemy. Only #{@enemy.life} XP left.")
          @enemy.hit(@player)
          return @game.stop(GameStatus::FAILED) if @player.dead?

          @game.display('** The enemy hits you. '\
                        "You only have #{@player.life} XP now.")
        end
      else
        @game.display('Hitting is not possible when there is no ennemy.')
      end
    end
  end
end
