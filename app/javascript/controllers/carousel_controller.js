import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="carousel"
export default class extends Controller {
  static targets = ["image"]
  static values = {
    index: 0
  }

  connect() {
    this.imageTargets[this.indexValue].classList.remove("hidden")
  }

  previous() {
    if (this.indexValue > 0) {
      this.imageTargets[this.indexValue].classList.add("hidden")
      this.indexValue -= 1
      this.imageTargets[this.indexValue].classList.remove("hidden")
    }
  }

  next() {
    if (this.indexValue < this.imageTargets.length - 1) {
      this.imageTargets[this.indexValue].classList.add("hidden")
      this.indexValue += 1
      this.imageTargets[this.indexValue].classList.remove("hidden")
    }
  }
}
