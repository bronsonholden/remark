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
      const url = new URL(document.location)
      if (this.inputTarget.value) {
        url.searchParams.set("search", encodeURIComponent(this.inputTarget.value))
      } else {
        url.searchParams.delete("search")
      }
      history.pushState(null, "", url.toString())
      this.formTarget.requestSubmit()
    }, 300)
  }
}
