# frozen_string_literal: true

require_relative 'base_action'

module Actions
  # Represents the class to perform move actions.
  class MoveAction < BaseAction
    def initialize(game, player, direction)
      super(game)
      @player = player
      @direction = direction
    end

    def do
      if @player.current_available_actions&.include?(@direction)
        @player.move(@direction)
      else
        @game.display('You hit the wall dumbass.')
      end
    end
  end
end
