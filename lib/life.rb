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
    on_damage_infliged
  end

  def on_damage_infliged=(callback)
    @on_damage_infliged_callback = callback
  end

  def dead?
    @life.zero?
  end

  private

  def on_damage_infliged
    @on_damage_infliged_callback&.call(@life)
  end
end
