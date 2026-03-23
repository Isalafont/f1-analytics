/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/stylesheets/**/*.css',
  ],
  theme: {
    extend: {
      colors: {
        // Backgrounds
        'f1-bg-base':     '#0D0D0D',
        'f1-bg-surface':  '#1A1A1A',
        'f1-bg-elevated': '#242424',
        'f1-bg-overlay':  '#2E2E2E',

        // Text
        'f1-text-primary':   '#F5F5F5',
        'f1-text-secondary': '#A0A0A0',
        'f1-text-muted':     '#606060',
        'f1-text-inverse':   '#0D0D0D',

        // Accents
        'f1-red':       '#E10600',
        'f1-red-hover': '#FF1A0F',
        'f1-teal':      '#27F4D2',
        'f1-teal-dim':  '#1BB99F',
        'f1-gold':      '#FFD700',
        'f1-silver':    '#C0C0C0',
        'f1-bronze':    '#CD7F32',

        // Borders
        'f1-border':        '#2E2E2E',
        'f1-border-subtle': '#1F1F1F',
        'f1-border-accent': '#E10600',

        // Teams
        'f1-team-redbull':     '#3671C6',
        'f1-team-ferrari':     '#E8002D',
        'f1-team-mclaren':     '#FF8000',
        'f1-team-mercedes':    '#27F4D2',
        'f1-team-astonmartin': '#229971',
        'f1-team-alpine':      '#0093CC',
        'f1-team-haas':        '#B6BABD',
        'f1-team-rb':          '#6692FF',
        'f1-team-sauber':      '#52E252',
        'f1-team-williams':    '#64C4FF',
        'f1-team-audi':        '#E2E61A',
        'f1-team-cadillac':    '#FFFFFF',
      },

      fontFamily: {
        'f1':   ['"Barlow"', 'system-ui', 'sans-serif'],
        'data': ['"JetBrains Mono"', '"Fira Code"', 'monospace'],
        'body': ['"Inter"', 'system-ui', 'sans-serif'],
      },

      fontSize: {
        'metric-xl': ['3rem',    { lineHeight: '1', fontWeight: '700' }],
        'metric-lg': ['2rem',    { lineHeight: '1', fontWeight: '700' }],
        'metric-md': ['1.5rem',  { lineHeight: '1', fontWeight: '600' }],
        'label':     ['0.75rem', { lineHeight: '1.2', fontWeight: '500', letterSpacing: '0.08em' }],
      },

      boxShadow: {
        'card':       '0 4px 6px rgba(0,0,0,0.4)',
        'card-hover': '0 8px 20px rgba(0,0,0,0.6)',
        'red-glow':   '0 0 20px rgba(225,6,0,0.3)',
        'teal-glow':  '0 0 20px rgba(39,244,210,0.2)',
      },

      borderRadius: {
        'card': '8px',
      },
    },
  },
  plugins: [],
}
