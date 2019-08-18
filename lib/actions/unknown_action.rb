# frozen_string_literal: true

require_relative 'base_action'

module Actions
  # Represents the class when action is unknown.
  class UnknownAction < BaseAction
    def do
      @game.display('Unknown action. See `help` command.')
    end
  end
end
