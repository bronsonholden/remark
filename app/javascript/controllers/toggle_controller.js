import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["element", "trigger"]
  static values = {
    className: "hidden",
    showLabel: "Show",
    hideLabel: "Hide"
  }

  click() {
    this.elementTarget.classList.toggle(this.classNameValue)
    this.triggerTarget.textContent = this.elementTarget.classList.contains(this.classNameValue) ? this.showLabelValue : this.hideLabelValue
  }
}
