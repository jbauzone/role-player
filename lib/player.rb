# frozen_string_literal: true

require_relative 'fight'
require_relative 'move'

# Represents a player crossing the map.
class Player
  include Fight
  include Move
end
