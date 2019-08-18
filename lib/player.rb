# frozen_string_literal: true

require_relative 'fight'
require_relative 'life'
require_relative 'move'

# Represents a player crossing the map.
class Player
  include Fight
  include Life
  include Move

  attr_accessor :current_available_actions
end
