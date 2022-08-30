class BackButtonComponent < ApplicationComponent
  def initialize(**options)
    @options = options
    @options[:aria_label] ||= "Go back"
    @options[:label] ||= "Back"
    @options[:icon] = "arrow-left"
    @options[:path] ||= :back
  end
end
