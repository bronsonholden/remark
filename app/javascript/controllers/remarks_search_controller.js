import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remarks-search"
export default class extends Controller {
  static targets = ["form", "input"]

  connect() {
    const params = (new URL(document.location)).searchParams
    const searchTerm = params.get("search")
    this.inputTarget.value = searchTerm
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 300)
  }
}
