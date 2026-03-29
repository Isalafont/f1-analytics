// app/javascript/controllers/chart_defaults_controller.js
// Configure Chart.js global defaults with F1 dark theme tokens.
// Connecté sur <body> dans application.html.erb (data-controller="chart-defaults")
// Doit être chargé avant tout chart — le body est le nœud racine idéal.

import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"

Chart.register(...registerables)

export default class extends Controller {
  connect() {
    // Text & grid colors (tokens CSS définis dans application.css)
    Chart.defaults.color         = "#A0A0A0" // --f1-text-secondary
    Chart.defaults.borderColor   = "#2E2E2E" // --f1-border
    Chart.defaults.backgroundColor = "#1A1A1A" // --f1-bg-surface

    // Legend
    Chart.defaults.plugins.legend.labels.color = "#F5F5F5" // --f1-text-primary

    // Tooltip
    Chart.defaults.plugins.tooltip.backgroundColor = "#242424" // --f1-bg-elevated
    Chart.defaults.plugins.tooltip.titleColor       = "#F5F5F5" // --f1-text-primary
    Chart.defaults.plugins.tooltip.bodyColor        = "#A0A0A0" // --f1-text-secondary
    Chart.defaults.plugins.tooltip.borderColor      = "#2E2E2E" // --f1-border
    Chart.defaults.plugins.tooltip.borderWidth      = 1

    // Axes
    Chart.defaults.scale.grid.color  = "#1F1F1F" // --f1-border-subtle
    Chart.defaults.scale.ticks.color = "#606060" // --f1-text-muted
  }
}
