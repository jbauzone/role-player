# frozen_string_literal: true

# Represents actions available to a player.
module Action
  MOVE_LEFT = 'left'
  MOVE_RIGHT = 'right'
  MOVE_TOP = 'top'
  MOVE_BOTTOM = 'bottom'

  HIT = 'hit'

  MOVE_ACTIONS = [MOVE_LEFT, MOVE_RIGHT, MOVE_TOP, MOVE_BOTTOM].freeze

  def self.description
    MOVE_ACTIONS.each do |action|
      puts "* \033[1;4m#{action}\033[0m  -  Move to #{action} direction."
    end

    puts "* \033[1;4mhit\033[0m  -  Hit an enemy to inflige him damages."
  end
end
