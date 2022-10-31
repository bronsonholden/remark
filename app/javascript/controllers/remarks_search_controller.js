import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remarks-search"
export default class extends Controller {
  static targets = ["form", "input", "clear"]

  connect() {
    const params = (new URL(document.location)).searchParams
    const searchTerm = params.get("search")
    if (searchTerm) {
      this.inputTarget.value = decodeURIComponent(searchTerm)
      this.clearTarget.classList.remove("hidden")
    } else {
      this.clearTarget.classList.add("hidden")
    }
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      const url = new URL(document.location)
      if (this.inputTarget.value) {
        url.searchParams.set("search", encodeURIComponent(this.inputTarget.value))
        this.clearTarget.classList.remove("hidden")
      } else {
        url.searchParams.delete("search")
        this.clearTarget.classList.add("hidden")
      }
      history.pushState(null, "", url.toString())
      this.formTarget.requestSubmit()
    }, 300)
  }

  clear() {
    this.inputTarget.value = ""
    this.search()
  }
}
