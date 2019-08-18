# frozen_string_literal: true

require_relative 'fight'
require_relative 'life'
require_relative 'move'

# Represents an enemy.
class Enemy
  include Fight
  include Life
  include Move
end
