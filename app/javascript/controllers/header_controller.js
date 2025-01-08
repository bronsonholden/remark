import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="header"
export default class extends Controller {
  static values = {
    offset: String,
    searchEnabled: Boolean = true
  }

  connect() {
    this.searchEnabledValue = false

    if (this.searchEnabledValue) {
      this.scrollY = 0

      this.listener = () => {
        if (this.muteEvents) {
          return
        }

        if (window.scrollY < this.scrollY - 50) {
          this.peek()
        } else if (window.scrollY > this.scrollY) {
          this.tuck()
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

  tuck() {
    this.element.classList.add(this.offsetValue)
    this.scrollY = window.scrollY
  }

  peek() {
    this.element.classList.remove(this.offsetValue)
    this.scrollY = window.scrollY
  }
}
