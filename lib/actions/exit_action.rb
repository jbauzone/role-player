# frozen_string_literal: true

require_relative 'base_action'

module Actions
  # Represents the class to perform exit action.
  class ExitAction < BaseAction
    def do
      @game.stop(GameStatus::EXITED)
    end
  end
end
