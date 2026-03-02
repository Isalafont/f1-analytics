# F1 Analytics 🏎️

> Dashboard personnel pour suivre la saison F1 2025 avec des métriques custom.  
> Parce qu'on n'a plus Canal+, on fait mieux.

---

## 🎯 C'est quoi?

App Rails perso pour visualiser la saison F1 avec des métriques avancées qu'on ne trouve nulle part ailleurs:

- **Performance Index** - Points pondérés par la fiabilité
- **Consistency Score** - Variance des temps au tour
- **Race Pace** - Positions gagnées/perdues pendant la course
- **Quali Pace** - Performance moyenne en qualification
- **Recent Form** - Moyenne glissante sur les 3 dernières courses

---

## 🛠️ Stack Technique

| Composant | Tech |
|-----------|------|
| Backend | Ruby 3.3 + Rails 7.2 |
| DB | SQLite3 |
| CSS | Tailwind CSS |
| Assets | Propshaft |
| Frontend | Hotwire/Turbo + Stimulus |
| Charts | Chart.js |
| Jobs | Good Job |
| Tests | RSpec + FactoryBot + Faker |
| Data | OpenF1 API (gratuit, pas de clé requise) |

---

## 🚀 Setup Local

### Prérequis

- Ruby 3.3 (`rbenv` ou `rvm`)
- Bundler
- SQLite3

### Installation

```bash
# 1. Cloner le repo
git clone <repo-url>
cd f1-analytics

# 2. Installer les gems
bundle install

# 3. Variables d'environnement
cp .env.example .env
# Éditer .env si nécessaire (OpenF1 ne requiert pas de clé!)

# 4. Base de données
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

# 5. Lancer l'app
bin/dev
```

> ⚠️ Toujours `bin/dev`, jamais `rails server` → lance Rails + Tailwind CSS watcher ensemble.

Ouvrir: `http://localhost:3000`

---

## 🗄️ Structure Base de Données

```
teams          → 10 écuries F1 2025
drivers        → 20 pilotes 2025 (liés aux teams)
races          → Calendrier 2025 (24 courses)
race_results   → Résultats par pilote par course
metrics        → Métriques custom calculées
weather        → Données météo par course
```

---

## 🏗️ Architecture

```
app/
├── models/          # AR models
├── controllers/     # Thin controllers
├── services/
│   └── f1/
│       ├── open_f1_client.rb    # Client API OpenF1
│       └── metrics_calculator.rb # Calcul métriques custom
├── jobs/
│   ├── fetch_race_results_job.rb  # Import résultats auto
│   └── calculate_metrics_job.rb   # Calcul métriques post-course
└── views/           # Hotwire/Turbo
```

---

## 📡 Source de Données

On utilise **OpenF1 API** (gratuit, open source):
- Base URL: `https://api.openf1.org/v1`
- Pas de clé API requise
- Données depuis 2023
- Délai live: ~3 secondes

**Endpoints principaux:**
```bash
/v1/sessions    → Calendrier et sessions
/v1/position    → Positions en course
/v1/laps        → Données par tour
/v1/pit         → Arrêts aux stands
/v1/drivers     → Info pilotes
```

> Documentation complète: `OPENF1_API.md`

---

## 🧪 Tests

```bash
# Tous les tests
bundle exec rspec

# Tests par dossier
bundle exec rspec spec/models/
bundle exec rspec spec/services/

# Linting
bundle exec rubocop

# Security
bundle exec brakeman
```

---

## 🗺️ Roadmap

### V1 - MVP (En cours)
- [ ] Dashboard pilotes + classement
- [ ] Dashboard écuries
- [ ] Métriques custom calculées
- [ ] Import données via OpenF1

### V2
- [ ] Graphiques Chart.js évolution saison
- [ ] Page détail pilote
- [ ] Notifications Discord post-course
- [ ] Prédictions ML basique

### V3
- [ ] Historical data 2023-2024
- [ ] Advanced analytics
- [ ] Déploiement VPS

---

## 👥 Équipe

| Rôle | Qui | Responsabilité |
|------|-----|----------------|
| 🦉 Orchestration | Owly | Priorisation, coordination |
| 🤖 Implémentation | Bender | Code, migrations, jobs |
| ✨ Documentation | Data | README, specs, API docs |
| 👩‍💻 Décisions | Isa | Review, merge, architecture |

---

## 📚 Documentation

- `CONTRIBUTING.md` - Git flow, conventions, PR process
- `OPENF1_API.md` - Documentation complète API OpenF1
- `TASKS.md` - Backlog et tâches en cours
- `LESSONS.md` - Leçons apprises en équipe

---

_Projet démarré: Mars 2026 | Stack: Rails 7.2 + Ruby 3.3_
