import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  connect() {
    if (localStorage.theme === "dark" || (!("theme" in localStorage) && window.matchMedia("(prefers-color-scheme: dark)").matches)) {
      document.documentElement.classList.add("dark")
    } else {
      document.documentElement.classList.remove("dark")
    }
  }

  toggle() {
    if ((!("theme" in localStorage))) {
      if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
        localStorage.theme = "dark"
      } else {
        localStorage.theme = "light"
      }
      this.toggle()
    } else if (localStorage.theme === "dark") {
      localStorage.theme = "light"
      document.documentElement.classList.remove("dark")
    } else {
      localStorage.theme = "dark"
      document.documentElement.classList.add("dark")
    }
  }
}
