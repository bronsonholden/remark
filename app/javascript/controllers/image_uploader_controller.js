import { Controller } from "@hotwired/stimulus"
import heic2any from "heic2any"

// Connects to data-controller="image-uploader"
export default class extends Controller {
  static targets = [
    "input", // file select input
    "data", // data inputs container
    "preview", // preview images
    "container", // container for preview images
    "placeholderIcon", // placeholder icon
    "submit" // form submit button
  ]
  static values = {
    loadingCount: 0
  }

  connect() {
    if (!this.inputTarget) {
      return
    }

    this.listener = () => {
      while (this.containerTarget.firstChild) this.containerTarget.removeChild(this.containerTarget.firstChild)
      while (this.dataTarget.firstChild) this.dataTarget.removeChild(this.dataTarget.firstChild)

      this.loadingCount = this.inputTarget.files.length
      this.submitTarget.disabled = true
      this.submitTarget.value = "Please wait..."

      { [...this.inputTarget.files].forEach(this.processImageFile) }
    }

    this.inputTarget.addEventListener("change", this.listener)
  }

  disconnect() {
    this.inputTarget.removeEventListener("change", this.listener)
  }

  processImageFile = (file, idx) => {
    const canvas = document.createElement("canvas")
    const img = document.createElement("img")
    const wrapper = document.createElement("div")
    const placeholder = this.placeholderIconTarget.cloneNode(true)

    placeholder.classList.remove("hidden")
    wrapper.classList.add("relative", "bg-gray-100", "dark:bg-gray-800", "rounded-lg", "min-h-12")
    img.classList.add("relative", "z-10", "rounded-lg", "overflow-hidden", "my-4")

    wrapper.appendChild(placeholder)
    wrapper.appendChild(img)

    canvas.classList.add("hidden")
    canvas.setAttribute("data-image-uploader-target", "preview")

    this.containerTarget.appendChild(canvas)
    this.containerTarget.appendChild(wrapper)

    const reader = new FileReader()

    reader.onload = (e) => {
      img.onload = (e) => {
        const canvas = this.previewTargets[idx]
        const context = canvas.getContext("2d")

        const width = e.target.naturalWidth
        const aspect = (1.0 * e.target.naturalWidth) / e.target.naturalHeight

        const resizedWidth = Math.min(width, 1024)
        const resizedHeight = resizedWidth / aspect
        canvas.width = resizedWidth
        canvas.height = resizedHeight

        context.drawImage(img, 0, 0, resizedWidth, resizedHeight)

        const dataInput = document.createElement("input")
        const dataUri = canvas.toDataURL("image/png", 1.0)

        dataInput.setAttribute("type", "hidden")
        dataInput.setAttribute("value", dataUri)
        dataInput.setAttribute("name", "image_data[]")

        this.dataTarget.appendChild(dataInput)

        this.loadingCount -= 1
        if (this.loadingCount === 0) {
          this.submitTarget.disabled = false
          this.submitTarget.value = "Send it"
        }
      }

      if (file.type === "image/heic") {
        heic2any({
          blob: file,
          toType: "image/png"
        }).then((result) => {
          img.src = URL.createObjectURL(result)
        })
      } else {
        img.src = e.target.result
      }
    }

    reader.readAsDataURL(file)
  }
}
