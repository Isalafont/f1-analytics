# CLAUDE.md — F1 Analytics 🏎️
> Instructions pour les agents IA travaillant sur ce repo.
> Maintenu par Data ✨ | Voir CONTRIBUTING.md pour la doc complète.

---

## Projet en une phrase

App Rails 8 de suivi de la saison F1 2026 avec métriques custom (Performance Index, Consistency Score, Race Pace, Quali Pace, Recent Form). Données : OpenF1 API (gratuit, sans clé).

---

## Stack

- Ruby 3.4.7 + Rails 8.0 + SQLite3
- Hotwire / Turbo / Stimulus + Tailwind CSS + Chart.js
- Solid Queue (background jobs) + RSpec + RuboCop + Brakeman
- Déployé sur Fly.io → `fly.toml`

---

## Architecture

```
app/
├── models/         # Driver, Team, Race, Result — AR standard
├── services/       # Logique métier (F1::DriverStatsService, etc.)
├── jobs/           # FetchRaceResultsJob, CalculateMetricsJob
├── queries/        # Requêtes AR complexes
├── presenters/     # Logique de vue
└── views/          # Hotwire/Turbo — zéro logique ici
```

**Règle fondamentale : controllers thin, logique dans services.**

---

## Commandes essentielles

```bash
bin/dev                          # Lancer l'app (Rails + Tailwind + Solid Queue)
bundle exec rspec                # Tests
bundle exec rubocop              # Linting
bundle exec rubocop -a           # Auto-fix
bundle exec brakeman             # Audit sécurité
bundle exec rails db:migrate
bundle exec rails db:seed        # Obligatoire — 11 équipes, 22 pilotes, 24 rounds
```

> ⚠️ Toujours `bin/dev`, jamais `rails server` seul.

---

## Workflow agents

### Rôles
| Agent | Responsabilité |
|-------|----------------|
| Owly 🦉 | Orchestration, priorisation, git — push/PR/merge via clé SSH GitHub (variable d'env) |
| Bender 🤖 | Code — models, services, jobs, migrations, tests |
| Data ✨ | Code review des PRs de Bender via API GitHub publique, documentation, specs |
| Iris 🎨 | Specs UX/design avant implémentation |
| Colette ✍️ | Copywriting, textes UI |

### Flow standard

```
Owly prend un ticket
  → besoin design ?  → Iris spec → Bender implémente
  → besoin copy ?    → Colette rédige → Bender intègre
  → code pur ?       → Bender directement
          ↓
  Bender produit le code + tests dans sa sandbox
          ↓
  Data review (cohérence, conventions, edge cases, lisibilité)
          ↓
  Data donne OK à Owly
          ↓
  Owly commit + push + ouvre PR (feature → develop)
          ↓
  CI vert (RSpec + RuboCop) → Owly merge
          ↓
  Owly notifie Isa : résumé de la PR mergée
```

### Signature commits obligatoire

```
feat(scope): description

Co-authored-by: Bender 🤖 <bender@f1-analytics.local>
Committed-by: Owly 🦉 <owly@f1-analytics.local>
Model: claude-sonnet-4-6 (Anthropic)
```

---

## Git flow

```
main      → production (protégée)
develop   → staging/intégration (protégée)
feature/* → nouvelles fonctionnalités
fix/*     → bug fixes
chore/*   → maintenance
docs/*    → documentation uniquement
```

**Règles absolues :**
- ❌ Jamais push direct sur `develop` ou `main`
- ✅ Toute branche part de `develop`
- ✅ PR `feature → develop` : CI vert + Data OK → Owly merge
- ✅ PR `develop → main` : Isa valide (prod)

**PRs avec dépendances :** préfixer le titre avec `[after #XX]` — Owly respecte l'ordre de merge.

---

## Conventions code

### Modèles — ordre obligatoire
```ruby
class Driver < ApplicationRecord
  # 1. Constants
  # 2. Associations
  # 3. Validations
  # 4. Scopes
  # 5. Callbacks (avec parcimonie)
  # 6. Instance methods
  # 7. private
end
```

### Migrations
```ruby
# ✅ Toujours réversibles
# ✅ Indexes + foreign keys obligatoires
# ❌ Jamais modifier une migration existante en prod
```

### Conventional Commits
`feat` | `fix` | `docs` | `style` | `refactor` | `test` | `chore` | `perf`

Exemples :
```
feat(dashboard): add driver performance index chart
fix(jobs): handle OpenF1 API timeout gracefully
test(models): add Race model validations specs
```

---

## Checklist PR (Bender)

Avant de passer à Data pour review :
- [ ] Tests RSpec écrits/mis à jour
- [ ] Pas de N+1 queries
- [ ] RuboCop passing
- [ ] Migrations réversibles + indexes + foreign keys
- [ ] Pas de commentaires laissés dans le code
- [ ] Description de PR claire

## Checklist review (Data)

Avant de donner OK à Owly :
- [ ] Cohérence avec l'architecture existante (thin controllers, services)
- [ ] Conventions de nommage respectées
- [ ] Edge cases couverts
- [ ] Tests présents et pertinents
- [ ] Pas de secrets committés
- [ ] Checklist Bender complète

---

## Fichiers de coordination

```
/shared/f1-analytics/
├── TASKS.md          → backlog + tâches en cours
├── STANDUP.md        → état du projet
├── LESSONS.md        → leçons apprises équipe
└── CONTRIBUTING.md   → doc complète git flow + conventions
```

---

_CLAUDE.md v1.0 — 2026-03-31 — Data ✨_
_Mettre à jour ce fichier si le workflow ou la stack change._
