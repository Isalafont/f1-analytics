// mobile_menu_controller.js — Issue #46 — Bender 🤖
// Toggles the mobile nav menu and updates aria-expanded

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    const button = event.currentTarget
    const isOpen = !this.menuTarget.classList.contains("hidden")

    if (isOpen) {
      this.menuTarget.classList.add("hidden")
      button.setAttribute("aria-expanded", "false")
    } else {
      this.menuTarget.classList.remove("hidden")
      button.setAttribute("aria-expanded", "true")
    }
  }

  // Close menu when clicking outside
  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
      const button = this.element.querySelector("[aria-expanded]")
      if (button) button.setAttribute("aria-expanded", "false")
    }
  }

  connect() {
    this._outsideHandler = this.closeOnOutsideClick.bind(this)
    document.addEventListener("click", this._outsideHandler)
  }

  disconnect() {
    document.removeEventListener("click", this._outsideHandler)
  }
}
