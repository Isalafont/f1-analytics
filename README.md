# F1 Analytics 🏎️

> Application Rails de suivi de la saison F1 2026 avec métriques custom.  
> Entièrement conçue et développée par une équipe d'agents IA. Supervisée par une humaine.

**Ce repo est lui-même une démo de développement multi-agents en production.**

---

## 🤖 Comment c'est construit

Ce projet est développé par une équipe de 5 agents IA travaillant de façon asynchrone, coordonnés via un workspace partagé :

| Agent | Rôle |
|-------|------|
| **Owly 🦉** | Orchestration, architecture, priorisation |
| **Bender 🤖** | Backend — models, services, jobs, migrations |
| **Data ✨** | Documentation, specs API, recherche |
| **Iris 🎨** | UX/Design — maquettes, specs visuelles |
| **Colette ✍️** | Copywriting, communication, documentation externe |

Les agents se coordonnent via des fichiers structurés (`TASKS.md`, `STANDUP.md`, `LESSONS.md`). Chaque agent a sa propre mémoire et son contexte de session. Supervision humaine : Isa valide et merge.

Construit avec [OpenClaw](https://github.com/openclaw/openclaw) — plateforme multi-agents IA.

---

## 🎯 Ce que ça fait

Suit la saison F1 2026 avec des métriques absentes des classements officiels :

- **Performance Index** — points pondérés par la fiabilité de la voiture (pénalise les DNF mécaniques)
- **Consistency Score** — variance des temps au tour sur la saison
- **Race Pace** — positions moyennes gagnées entre la grille et l'arrivée
- **Quali Pace** — performance moyenne en qualification
- **Recent Form** — moyenne glissante sur les 3 dernières courses

Données récupérées automatiquement depuis l'[OpenF1 API](https://openf1.org) (gratuit, sans clé requise).

---

## 🛠️ Stack

| Composant | Tech |
|-----------|------|
| Backend | Ruby **3.4.7** + Rails **~> 8.0** |
| Base de données | SQLite3 |
| CSS | Tailwind CSS |
| Assets | Propshaft |
| Frontend | Hotwire / Turbo / Stimulus |
| Charts | Chart.js |
| Background Jobs | Solid Queue |
| Tests | RSpec ~> 6.1 + FactoryBot + Faker |
| Linting | RuboCop + rubocop-rails + rubocop-rspec |
| Sécurité | Brakeman |
| Données | [OpenF1 API](https://openf1.org) |

---

## 🏗️ Architecture

```
app/
├── models/         # Driver, Team, Race, Result
├── services/
│   └── f1_api_client.rb       # Wrapper OpenF1 API
├── jobs/
│   ├── fetch_race_results_job.rb    # Auto-déclenché après chaque GP
│   └── calculate_metrics_job.rb     # Calcul métriques custom
└── views/          # Dashboard Hotwire
```

**Pipeline background jobs :**
1. `FetchRaceResultsJob` se déclenche après chaque GP → récupère les résultats depuis OpenF1 API
2. `CalculateMetricsJob` recalcule les 5 métriques par pilote
3. Dashboard mis à jour via Turbo Streams

---

## 🚀 Setup

### Prérequis

- Ruby 3.4.7 (`rbenv` recommandé : `rbenv install 3.4.7`)
- Bundler (`gem install bundler`)
- SQLite3 (`brew install sqlite3` ou `apt install libsqlite3-dev`)
- Node.js (pour le Tailwind CSS watcher)

### Installation

```bash
git clone https://github.com/Isalafont/f1-analytics
cd f1-analytics

bundle install

bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed    # Obligatoire — charge les 11 équipes, 22 pilotes, 24 rounds 2026

bin/dev                      # Lance Rails + Tailwind watcher + Solid Queue
```

> ⚠️ Toujours utiliser `bin/dev` (pas `rails server` seul) — il lance Rails, le Tailwind watcher et Solid Queue ensemble.

### Variables d'environnement

L'API OpenF1 est publique — **aucune clé requise**.  
Pas de configuration d'environnement nécessaire pour faire tourner l'app.  
Un fichier `.env.example` sera fourni prochainement pour les configs optionnelles.

---

## 📅 Saison 2026

- 24 rounds au calendrier
- Round 1 (Melbourne GP) terminé — données disponibles
- Mise à jour automatique via OpenF1 au fil de la saison
- Seeds : 11 écuries, 22 pilotes (dont Audi + Cadillac, nouveaux constructeurs 2026)

---

## 📸 Screenshots

> *(à venir — dashboard en cours de développement)*

---

## 📚 Documentation

- `CONTRIBUTING.md` — Git flow, conventions, process PR
- `OPENF1_API.md` — Documentation complète API OpenF1
- `TASKS.md` — Backlog et tâches en cours
- `LESSONS.md` — Leçons apprises en équipe

---

## 👥 Équipe

| Rôle | Agent | Responsabilité |
|------|-------|----------------|
| Orchestration | Owly 🦉 | Priorisation, coordination |
| Implémentation | Bender 🤖 | Code, migrations, jobs |
| Documentation | Data ✨ | Specs API, recherche |
| Design | Iris 🎨 | UX/UI, maquettes, specs visuelles |
| Communication | Colette ✍️ | Copywriting, README, personal brand |
| Supervision | Isa 👩‍💻 | Review, merge, architecture |

---

_Projet démarré : Mars 2026 — Stack : Rails 8.0 + Ruby 3.4.7 + OpenClaw_  
_Questions sur le setup multi-agents ? → [isalafont.netlify.app](https://isalafont.netlify.app)_
