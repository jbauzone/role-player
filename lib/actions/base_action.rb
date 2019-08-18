# frozen_string_literal: true

module Actions
  # Represents the base class to perform actions.
  class BaseAction
    def initialize(game)
      @game = game
    end

    def do
      raise NotImplementedError,
            "#{self.class} has not implemented method '#{__method__}'"
    end
  end
end
