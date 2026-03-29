// points_evolution_chart_controller.js — Issue #45 — Bender 🤖
// Line chart: cumulative points evolution for a driver + optional teammate

import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"
import { getTeamColor, formatRaceName } from "./chart_helpers"

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    // [{race_name: "Australian Grand Prix", points: 25, cumulative: 25}, ...]
    results: Array,
    // [{race_name: "...", points: ..., cumulative: ...}, ...] — empty array if no teammate
    teammate: Array,
    teamKey: String,     // e.g. "redbull"
    driverName: String,  // last name for legend
    teammateName: String,
  }

  connect() {
    this.chart = new Chart(this.canvasTarget, this.chartConfig())
  }

  disconnect() {
    this.chart?.destroy()
  }

  chartConfig() {
    const results = this.resultsValue || []
    const teammate = this.teammateValue || []
    const hasTeammate = teammate.length > 0
    const teamColor = getTeamColor(this.teamKeyValue)
    const isMobile = window.matchMedia("(max-width: 639px)").matches

    const labels = results.map(r => formatRaceName(r.race_name))

    const datasets = [
      {
        label: this.driverNameValue || "Driver",
        data: results.map(r => r.cumulative),
        borderColor: teamColor,
        backgroundColor: teamColor + "1A", // 10% alpha fill
        fill: true,
        tension: 0.3,
        pointRadius: 4,
        pointHoverRadius: 7,
        pointBackgroundColor: teamColor,
        borderWidth: 2,
      },
    ]

    if (hasTeammate) {
      datasets.push({
        label: this.teammateNameValue || "Teammate",
        data: teammate.map(r => r.cumulative),
        borderColor: "#606060",
        backgroundColor: "transparent",
        fill: false,
        tension: 0.3,
        pointRadius: 3,
        pointHoverRadius: 5,
        borderDash: [4, 4],
        borderWidth: 1.5,
      })
    }

    return {
      type: "line",
      data: { labels, datasets },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        animation: { duration: 500, easing: "easeOutCubic" },

        interaction: {
          mode: "index",
          intersect: false,
        },

        plugins: {
          legend: {
            display: hasTeammate,
            position: "top",
            align: "end",
            labels: {
              color: "#A0A0A0",
              font: { family: "'Inter', sans-serif", size: 11 },
              boxWidth: 12,
              padding: 16,
              usePointStyle: true,
            },
          },
          tooltip: {
            backgroundColor: "#242424",
            titleColor: "#F5F5F5",
            bodyColor: "#A0A0A0",
            borderColor: "#2E2E2E",
            borderWidth: 1,
            callbacks: {
              title: (items) => items[0].label,
              label: (item) => `${item.dataset.label}: ${item.raw} pts`,
            },
          },
        },

        scales: {
          x: {
            grid: { color: "#1F1F1F" },
            ticks: {
              color: "#606060",
              font: { family: "'JetBrains Mono', monospace", size: 10 },
              maxRotation: 45,
              maxTicksLimit: isMobile ? 8 : 24,
            },
            border: { color: "#2E2E2E" },
          },
          y: {
            grid: { color: "#1F1F1F" },
            ticks: {
              color: "#606060",
              font: { family: "'JetBrains Mono', monospace", size: 11 },
              callback: (val) => `${val} pts`,
            },
            border: { color: "#2E2E2E" },
            beginAtZero: true,
          },
        },
      },
    }
  }
}
