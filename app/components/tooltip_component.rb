# frozen_string_literal: true

class TooltipComponent < ApplicationComponent
  def initialize(**options)
    @options = options
    @options[:direction] ||= :bottom
  end
end
