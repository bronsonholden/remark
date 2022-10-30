import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="carousel"
export default class extends Controller {
  static targets = ["image", "previous", "next"]
  static values = {
    index: 0
  }

  connect() {
    this.imageTargets[this.indexValue].classList.remove("hidden")
    this.updateControlVisibility()
  }

  updateControlVisibility() {
    if (this.imageTargets.length < 2) {
      return
    }

    if (this.indexValue === 0) {
      this.previousTarget.classList.add("hidden")
    } else {
      this.previousTarget.classList.remove("hidden")
    }

    if (this.indexValue === this.imageTargets.length - 1) {
      this.nextTarget.classList.add("hidden")
    } else {
      this.nextTarget.classList.remove("hidden")
    }
  }

  previous() {
    if (this.indexValue > 0) {
      this.imageTargets[this.indexValue].classList.add("hidden")
      this.indexValue -= 1
      this.imageTargets[this.indexValue].classList.remove("hidden")
    }

    this.updateControlVisibility()
  }

  next() {
    if (this.indexValue < this.imageTargets.length - 1) {
      this.imageTargets[this.indexValue].classList.add("hidden")
      this.indexValue += 1
      this.imageTargets[this.indexValue].classList.remove("hidden")
    }

    this.updateControlVisibility()
  }
}
