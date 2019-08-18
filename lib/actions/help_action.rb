# frozen_string_literal: true

require_relative 'base_action'

module Actions
  # Represents the class to perform help action.
  class HelpAction < BaseAction
    def initialize(game, player)
      super(game)
      @player = player
    end

    def do
      @game.display('--- ROLE-PLAYER ---')
      @game.display('Global commands:')
      @game.display("* \033[1;4mhelp\033[0m  -   This page.")
      @game.display("* \033[1;4mexit\033[0m  -   Ends the game. You will "\
                    'fail to save the Humanity and run like a coward.')
      @game.display(Action.description)

      player_actions = @player.current_available_actions

      return unless player_actions

      @game.display('')
      @game.display('Current available commands: '\
                    "\033[1;4m#{player_actions.join('/')}\033[0m")
    end
  end
end
