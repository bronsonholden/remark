import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-conversion"
export default class extends Controller {
  connect() {
  }

  convert() {
    const searchId = this.element.getAttribute("data-search-id")
    const remarkId = this.element.getAttribute("data-remark-id")

    if (!searchId) {
      return
    }

    fetch(`searches/${searchId}/convert?remark_id=${remarkId}`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      }
    }).then((res) => {
    })
  }
}
