# frozen_string_literal: true

# Represents a way to fight someone.
module Fight
  DAMAGE_TO_BE_DONE = 50

  def hit(other)
    other.suffered(DAMAGE_TO_BE_DONE)
  end
end
