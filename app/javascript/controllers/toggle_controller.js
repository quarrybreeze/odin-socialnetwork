import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "button", "button2" ]
  static classes = [ "primary" ]

  connect () {
    if (this.hasButtonTarget) {
    this.buttonTarget.classList.add(this.primaryClass)
    }
  }

  clicked () {
    if (this.hasButtonTarget) {
    this.buttonTarget.classList.toggle(this.primaryClass)
    }

    if (this.hasButton2Target) {
      this.button2Target.classList.toggle(this.primaryClass)
    }
  }
}