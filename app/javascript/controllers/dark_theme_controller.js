import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dark-theme"
export default class extends Controller {
  static targets = ["icon", "lightOption", "darkOption", "autoOption", "dropdownButton"]

  connect() {
    // Инициализируем mediaQuery для отслеживания системной темы
    this.mediaQuery = window.matchMedia("(prefers-color-scheme: dark)")
    this.mediaQuery.addEventListener("change", this.handleSystemThemeChange.bind(this))
    
    // Загружаем сохраненный режим или используем "auto"
    const savedMode = localStorage.getItem("theme-mode") || "auto"
    this.setMode(savedMode)
  }

  disconnect() {
    if (this.mediaQuery) {
      this.mediaQuery.removeEventListener("change", this.handleSystemThemeChange.bind(this))
    }
  }

  handleSystemThemeChange(e) {
    const currentMode = localStorage.getItem("theme-mode") || "auto"
    if (currentMode === "auto") {
      this.applyTheme(e.matches ? "dark" : "light")
    }
  }

  setLight(event) {
    this.setMode("light")
    this.closeDropdown()
  }

  setDark(event) {
    this.setMode("dark")
    this.closeDropdown()
  }

  setAuto(event) {
    this.setMode("auto")
    this.closeDropdown()
  }

  closeDropdown() {
    if (this.hasDropdownButtonTarget) {
      const dropdown = bootstrap.Dropdown.getInstance(this.dropdownButtonTarget)
      if (dropdown) {
        dropdown.hide()
      }
    }
  }

  setMode(mode) {
    localStorage.setItem("theme-mode", mode)
    
    if (mode === "auto") {
      // В режиме "auto" применяем системную тему
      const systemTheme = this.mediaQuery.matches ? "dark" : "light"
      this.applyTheme(systemTheme)
    } else {
      // В режимах "light" или "dark" применяем напрямую
      this.applyTheme(mode)
    }
    
    // Обновляем иконку и активное состояние опций
    this.updateIcon(mode)
    this.updateActiveOption(mode)
  }

  applyTheme(theme) {
    document.documentElement.setAttribute("data-bs-theme", theme)
    document.querySelectorAll('.language-ruby')
  }

  updateIcon(mode) {
    if (!this.hasIconTarget) return
    
    // Удаляем все возможные иконки
    this.iconTarget.classList.remove("bi-sun-fill", "bi-moon-fill", "bi-circle-half")
    
    // Добавляем нужную иконку
    if (mode === "light") {
      this.iconTarget.classList.add("bi-sun-fill")
    } else if (mode === "dark") {
      this.iconTarget.classList.add("bi-moon-fill")
    } else {
      // "auto" - используем иконку половины круга
      this.iconTarget.classList.add("bi-circle-half")
    }
  }

  updateActiveOption(mode) {
    // Убираем активное состояние со всех опций
    if (this.hasLightOptionTarget) {
      this.lightOptionTarget.classList.remove("active")
    }
    if (this.hasDarkOptionTarget) {
      this.darkOptionTarget.classList.remove("active")
    }
    if (this.hasAutoOptionTarget) {
      this.autoOptionTarget.classList.remove("active")
    }
    
    // Добавляем активное состояние к текущей опции
    if (mode === "light" && this.hasLightOptionTarget) {
      this.lightOptionTarget.classList.add("active")
    } else if (mode === "dark" && this.hasDarkOptionTarget) {
      this.darkOptionTarget.classList.add("active")
    } else if (mode === "auto" && this.hasAutoOptionTarget) {
      this.autoOptionTarget.classList.add("active")
    }
  }
}
