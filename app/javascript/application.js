// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "channels"

const mql = window.matchMedia("(prefers-color-scheme: dark)")

mql.onchange = (event) => {
  if ("theme" in localStorage) {
    return
  }
  if (event.target.matches) {
    document.documentElement.classList.add("dark")
  } else {
    document.documentElement.classList.remove("dark")
  }
}
