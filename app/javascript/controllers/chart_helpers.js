// chart_helpers.js — shared utilities for F1 chart controllers

/**
 * Get the CSS variable value for a team's color.
 * @param {string} teamKey - e.g. "redbull", "ferrari", "mclaren"
 * @returns {string} hex color string
 */
export function getTeamColor(teamKey) {
  return getComputedStyle(document.documentElement)
    .getPropertyValue(`--f1-team-${teamKey}`)
    .trim()
}

/**
 * Format a race name to a short 3-letter code.
 * Prefers known abbreviations, falls back to first 3 chars.
 * @param {string} raceName
 * @returns {string}
 */
export function formatRaceName(raceName) {
  const known = {
    "Australian Grand Prix": "AUS",
    "Chinese Grand Prix": "CHN",
    "Japanese Grand Prix": "JPN",
    "Bahrain Grand Prix": "BHR",
    "Saudi Arabian Grand Prix": "SAU",
    "Miami Grand Prix": "MIA",
    "Canadian Grand Prix": "CAN",
    "Monaco Grand Prix": "MON",
    "Spanish Grand Prix": "ESP",
    "Austrian Grand Prix": "AUT",
    "British Grand Prix": "GBR",
    "Belgian Grand Prix": "BEL",
    "Hungarian Grand Prix": "HUN",
    "Dutch Grand Prix": "NED",
    "Italian Grand Prix": "ITA",
    "Madrid Grand Prix": "MAD",
    "Azerbaijan Grand Prix": "AZE",
    "Singapore Grand Prix": "SGP",
    "United States Grand Prix": "USA",
    "Mexico City Grand Prix": "MEX",
    "São Paulo Grand Prix": "BRA",
    "Las Vegas Grand Prix": "LAS",
    "Qatar Grand Prix": "QAT",
    "Abu Dhabi Grand Prix": "ABU",
  }
  return known[raceName] || raceName.slice(0, 3).toUpperCase()
}

/**
 * Shared Chart.js global options applied to all F1 charts.
 * Call once per page (chart_defaults_controller handles it for the whole app).
 */
export const F1_CHART_DEFAULTS = {
  color: "#A0A0A0",
  borderColor: "#2E2E2E",
  backgroundColor: "#1A1A1A",
  font: { family: "'Inter', system-ui, sans-serif" },
}
