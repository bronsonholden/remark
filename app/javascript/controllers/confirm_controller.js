import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    classes: Object,
    message: String,
    timeout: { type: Number, default: 5000 },
    enableTimeout: { type: Number, default: 1000 }
  }

  connect() {
    this.defaultMessage = this.element.textContent
  }

  disconnect() {
    this.revert()
  }

  click(event) {
    if (!this.clicked) {
      event.preventDefault()
      event.stopPropagation()

      const addClasses = this.classesValue.add.split(" ")
      const removeClasses = this.classesValue.remove.split(" ")

      removeClasses.forEach((c) => this.element.classList.remove(c))
      addClasses.forEach((c) => this.element.classList.add(c))

      this.clicked = true
      this.elapsed = 0

      this.timeoutInterval = setInterval(() => {
        if (this.elapsed + 100 >= this.timeoutValue) {
          this.revert()
        } else {
          this.elapsed += 100
          this.updateLabel()
        }
      }, 100)

      if (this.enableTimeoutValue > 0) {
        this.element.setAttribute("disabled", true)
        this.enableTimeout = setTimeout(() => {
          this.element.removeAttribute("disabled")
        }, this.enableTimeoutValue)
      }

      this.updateLabel()
    }
  }

  updateLabel() {
    const label = this.messageValue || this.defaultMessage
    this.element.textContent = `(${Math.ceil(this.timeRemaining() / 1000)}) ${label}`
  }

  revert() {
    if (this.timeoutInterval) {
      clearInterval(this.timeoutInterval)
      this.timeoutInterval = null
    }

    if (this.enableTimeout) {
      clearTimeout(this.enableTimeout)
      this.enableTimeout = null
    }

    const addClasses = this.classesValue.add.split(" ")
    const removeClasses = this.classesValue.remove.split(" ")

    addClasses.forEach((c) => this.element.classList.remove(c))
    removeClasses.forEach((c) => this.element.classList.add(c))

    this.element.textContent = this.defaultMessage

    this.clicked = false
    this.elapsed = 0
  }

  timeRemaining() {
    if (!this.clicked) {
      return 0
    }

    return this.timeoutValue - this.elapsed
  }
}
