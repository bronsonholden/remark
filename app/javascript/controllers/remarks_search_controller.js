import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remarks-search"
export default class extends Controller {
  static targets = ["form", "input"]

  connect() {
    const params = (new URL(document.location)).searchParams
    const searchTerm = params.get("search")
    if (searchTerm) {
      this.inputTarget.value = decodeURIComponent(searchTerm)
    }
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      const params = (new URL(document.location)).searchParams
      params.set("search", encodeURIComponent(this.inputTarget.value))
      const path = `${window.location.pathname}?${params.toString()}`
      history.pushState(null, "", path)
      this.formTarget.requestSubmit()
    }, 300)
  }
}
