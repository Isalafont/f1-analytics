// team_performance_chart_controller.js — Issue #45 — Bender 🤖
// Grouped bar chart: per-race points contribution per driver in a team

import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
import { getTeamColor, formatRaceName } from "./chart_helpers"

Chart.register(...registerables)

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    // {
    //   team_key: "redbull",
    //   driver1: { name: "Verstappen", results: [{race_name: "...", points: 25}, ...] },
    //   driver2: { name: "Hadjar",     results: [{race_name: "...", points: 12}, ...] }
    // }
    results: Object,
  }

  connect() {
    this.chart = new Chart(this.canvasTarget, this.chartConfig())
  }

  disconnect() {
    this.chart?.destroy()
  }

  chartConfig() {
    const data = this.resultsValue || {}
    const teamColor = getTeamColor(data.team_key || "redbull")
    const driver1 = data.driver1 || { name: "Driver 1", results: [] }
    const driver2 = data.driver2 || { name: "Driver 2", results: [] }
    const isMobile = window.matchMedia("(max-width: 639px)").matches

    // Build aligned labels from driver1 results (both drivers share the same races)
    const labels = driver1.results.map(r => formatRaceName(r.race_name))

    return {
      type: "bar",
      data: {
        labels,
        datasets: [
          {
            label: driver1.name,
            data: driver1.results.map(r => r.points),
            backgroundColor: teamColor,
            borderColor: teamColor,
            borderWidth: 1,
            borderRadius: 3,
          },
          {
            label: driver2.name,
            data: driver2.results.map(r => r.points),
            backgroundColor: teamColor + "80", // 50% alpha
            borderColor: teamColor,
            borderWidth: 1,
            borderRadius: 3,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        animation: { duration: 400, easing: "easeOutQuart" },

        plugins: {
          legend: {
            display: true,
            position: "top",
            align: "end",
            labels: {
              color: "#A0A0A0",
              font: { family: "'Inter', sans-serif", size: 11 },
              boxWidth: 12,
              usePointStyle: true,
            },
          },
          tooltip: {
            mode: "index",
            intersect: false,
            backgroundColor: "#242424",
            titleColor: "#F5F5F5",
            bodyColor: "#A0A0A0",
            borderColor: "#2E2E2E",
            borderWidth: 1,
            callbacks: {
              title: (items) => items[0].label,
              label: (item) => `${item.dataset.label}: ${item.raw} pts`,
              footer: (items) => {
                const total = items.reduce((sum, i) => sum + (i.raw || 0), 0)
                return `Team total: ${total} pts`
              },
            },
          },
        },

        scales: {
          x: {
            grid: { display: false },
            ticks: {
              color: "#606060",
              font: { family: "'JetBrains Mono', monospace", size: 10 },
              maxRotation: 45,
              maxTicksLimit: isMobile ? 6 : 24,
            },
            border: { color: "#2E2E2E" },
          },
          y: {
            grid: { color: "#1F1F1F" },
            ticks: {
              color: "#606060",
              font: { family: "'JetBrains Mono', monospace", size: 11 },
              stepSize: 5,
            },
            border: { color: "#2E2E2E" },
            beginAtZero: true,
          },
        },
      },
    }
  }
}
