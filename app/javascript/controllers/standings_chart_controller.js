// standings_chart_controller.js — Issue #45 — Bender 🤖
// Horizontal bar chart: Driver Championship Standings

import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
import { getTeamColor, formatRaceName } from "./chart_helpers"

Chart.register(...registerables)

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    drivers: Array,   // [{id, last_name, team_key, team_name, total_points}]
    limit: { type: Number, default: 22 },
  }

  connect() {
    this.chart = new Chart(this.canvasTarget, this.chartConfig())
    this.updateContainerHeight()
  }

  disconnect() {
    this.chart?.destroy()
  }

  // Reduce to top 10 on small screens, show all on desktop
  updateContainerHeight() {
    const isMobile = window.matchMedia("(max-width: 639px)").matches
    const container = this.canvasTarget.parentElement
    if (isMobile) {
      container.style.height = "320px"
      if (this.chart) {
        this.chart.data.labels = this.visibleDrivers(10).map(d => d.last_name)
        this.chart.data.datasets[0].data = this.visibleDrivers(10).map(d => d.total_points)
        this.chart.data.datasets[0].backgroundColor = this.visibleDrivers(10).map(d => getTeamColor(d.team_key))
        this.chart.data.datasets[0].borderColor = this.visibleDrivers(10).map(d => getTeamColor(d.team_key))
        this.chart.update()
      }
    }
  }

  visibleDrivers(n = null) {
    const limit = n || this.limitValue
    return (this.driversValue || []).slice(0, limit)
  }

  chartConfig() {
    const drivers = this.visibleDrivers()
    const colors = drivers.map(d => getTeamColor(d.team_key))

    return {
      type: "bar",
      data: {
        labels: drivers.map(d => d.last_name),
        datasets: [{
          data: drivers.map(d => d.total_points),
          backgroundColor: colors.map(c => c + "D9"), // ~85% opacity
          borderColor: colors,
          borderWidth: 1,
          borderRadius: 4,
        }],
      },
      options: {
        indexAxis: "y",
        responsive: true,
        maintainAspectRatio: false,
        animation: { duration: 400, easing: "easeOutQuart" },

        plugins: {
          legend: { display: false },
          tooltip: {
            backgroundColor: "#242424",
            titleColor: "#F5F5F5",
            bodyColor: "#A0A0A0",
            borderColor: "#2E2E2E",
            borderWidth: 1,
            callbacks: {
              title: (items) => items[0].label,
              label: (item) => `${item.raw} pts`,
              afterLabel: (item) => {
                const driver = drivers[item.dataIndex]
                return `${driver.team_name} · P${item.dataIndex + 1}`
              },
            },
          },
        },

        scales: {
          x: {
            grid: { color: "#1F1F1F" },
            ticks: {
              color: "#606060",
              font: { family: "'JetBrains Mono', monospace", size: 11 },
            },
            border: { color: "#2E2E2E" },
          },
          y: {
            grid: { display: false },
            ticks: {
              color: "#F5F5F5",
              font: { family: "'Inter', sans-serif", size: 12 },
            },
            border: { color: "#2E2E2E" },
          },
        },
      },
    }
  }
}
