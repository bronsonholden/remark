import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="header"
export default class extends Controller {
  static values = {
    offset: String,
    searchEnabled: Boolean = true
  }

  connect() {
    if (this.searchEnabledValue) {
      this.scrollY = 0

      this.listener = () => {
        if (window.scrollY < this.scrollY - 50) {
          this.element.classList.remove(this.offsetValue)
          this.scrollY = window.scrollY
        } else if (window.scrollY > this.scrollY) {
          this.element.classList.add(this.offsetValue)
          this.scrollY = window.scrollY
        }
      }

      window.addEventListener("scroll", this.listener)
    } else {
      this.element.classList.remove(this.offsetValue)
      this.element.classList.add("top-0")
    }
  }

  disconnect() {
    if (this.searchEnabledValue) {
      window.removeEventListener("scroll", this.listener)
    }
  }
}
