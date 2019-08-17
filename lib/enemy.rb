# frozen_string_literal: true

require_relative 'life'
require_relative 'move'

# Represents an enemy.
class Enemy
  include Life
  include Move
end
