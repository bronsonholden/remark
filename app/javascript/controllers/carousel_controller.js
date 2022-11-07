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
      this.scrollToCurrentImage()
    }

    this.updateControlVisibility()
  }

  next() {
    if (this.indexValue < this.imageTargets.length - 1) {
      this.imageTargets[this.indexValue].classList.add("hidden")
      this.indexValue += 1
      this.imageTargets[this.indexValue].classList.remove("hidden")
      this.scrollToCurrentImage()
    }

    this.updateControlVisibility()
  }

  scrollToCurrentImage() {
    const { top, bottom, height } = this.currentImage.getBoundingClientRect()
    const topOverflow = 120 - top
    const bottomOverflow = bottom - window.innerHeight
    const threshold = 0.08
    const maxOverflow = threshold * height

    const headerController = this.application.getControllerForElementAndIdentifier(
      document.querySelector("#header"),
      "header"
    )

    if (bottomOverflow > maxOverflow || topOverflow > 0) {
      if (headerController) {
        headerController.tuck()
        headerController.muteEvents = true
      }
      this.imageTargets[this.indexValue].scrollIntoView({
        alignToTop: false,
        behavior: "smooth",
        block: "center"
      })
      if (headerController) {
        setTimeout(() => { headerController.muteEvents = false }, 800)
      }
    }
  }

  get currentImage() {
    return this.imageTargets[this.indexValue]
  }
}
