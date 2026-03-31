// chart_helpers.js — shared utilities for F1 chart controllers

// Fallback hardcoded colors — used when CSS vars are not resolved (e.g. before stylesheets load,
// or if --f1-team-* vars are missing). Must stay in sync with application.css :root block.
const TEAM_COLORS = {
  redbull:     "#3671C6",
  ferrari:     "#E8002D",
  mclaren:     "#FF8000",
  mercedes:    "#27F4D2",
  astonmartin: "#229971",
  alpine:      "#0093CC",
  haas:        "#B6BABD",
  rb:          "#6692FF",
  sauber:      "#52E252",
  williams:    "#64C4FF",
  audi:        "#E2E61A",
  cadillac:    "#FFFFFF",
}

/**
 * Get the color for a team key.
 * Tries CSS var first (--f1-team-{teamKey}), falls back to hardcoded map.
 * Chart.js cannot resolve CSS var strings — resolved hex value is required.
 * @param {string} teamKey - e.g. "redbull", "ferrari", "mclaren"
 * @returns {string} hex color string
 */
export function getTeamColor(teamKey) {
  const fromVar = getComputedStyle(document.documentElement)
    .getPropertyValue(`--f1-team-${teamKey}`)
    .trim()
  return fromVar || TEAM_COLORS[teamKey] || "#A0A0A0"
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
