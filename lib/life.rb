# frozen_string_literal: true

# Represents life.
module Life
  attr_reader :life

  def initialize(life)
    raise ArgumentError, 'life can only be positive.' unless life.positive?

    @life = life
  end

  def suffered(damage)
    @life = @life >= damage ? @life - damage : 0
  end

  def dead?
    @life.zero?
  end
end
