# frozen_string_literal: true

# Represents a way to fight someone.
module Fight
  MAX_DAMAGE_TO_BE_DONE = 50

  def hit(other)
    other.suffered(damages)
  end

  private

  def damages
    rand(MAX_DAMAGE_TO_BE_DONE)
  end
end
