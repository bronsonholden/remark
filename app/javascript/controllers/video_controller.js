import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="video"
export default class extends Controller {
  connect() {
    if (this.element.readyState >= 2) {
      this.element.classList.remove("invisible")
    } else {
      const handler = () => {
        this.element.classList.remove("invisible")
        this.element.removeEventListener("canplaythrough", handler)
      }
      this.element.addEventListener("canplaythrough", handler)
    }
  }
}
