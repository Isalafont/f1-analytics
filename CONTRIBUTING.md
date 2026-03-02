# Contributing - F1 Analytics 🏎️

> Document officiel maintenu par Data ✨  
> Orchestré par Owly 🦉 | Validé par Bender 🤖 | Supervisé par Isa

---

## 🌿 Git Flow

### Branches

```
main          → Production (stable, deployable, protégée)
develop       → Intégration / staging (protégée)
feature/*     → Nouvelles fonctionnalités
fix/*         → Bug fixes
chore/*       → Maintenance (deps, config)
docs/*        → Documentation uniquement
```

### Workflow

```
main (production)
  ↑ PR develop→main : Isa obligatoire + CI vert
develop (staging)
  ↑ PR feature→develop : review équipe (Bender ou Data)
feature/driver-standings   fix/openf1-timeout   chore/rubocop
```

**Règles absolues:**
- ❌ Jamais de push direct sur `develop` ou `main`
- ✅ Tout travail commence par une branche depuis `develop`
- ✅ Nommage: `feature/xxx`, `fix/xxx`, `chore/xxx`, `docs/xxx`
- ✅ PR `feature → develop`: 1 approval équipe (Bender ou Data)
- ✅ PR `develop → main`: **Isa obligatoire** + CI vert (rubocop + rspec)
- ✅ `main` = production, on ne merge que quand `develop` est propre et stable

---

## 📝 Conventional Commits

Format: **Conventional Commits**

```
<type>(<scope>): <description courte>

[body optionnel]

[footer optionnel]
```

### Types

| Type | Usage |
|------|-------|
| `feat` | Nouvelle fonctionnalité |
| `fix` | Bug fix |
| `docs` | Documentation |
| `style` | Formatting (pas de logique) |
| `refactor` | Refactoring sans new feature/fix |
| `test` | Ajout/modif tests |
| `chore` | Maintenance, deps |
| `perf` | Amélioration performance |

### Exemples concrets F1

```bash
feat(dashboard): add driver performance index chart
fix(jobs): handle Ergast API timeout gracefully
test(models): add Race model validations specs
chore(deps): update good_job to 4.x
docs(api): document Ergast service usage
refactor(services): extract race pace calculation
perf(queries): add index on race_results.driver_id
```

---

## 🔀 Pull Request Process

### Nommage PR

```
[TYPE] Description courte
```

Exemples:
- `[FEAT] Driver performance dashboard`
- `[FIX] Race import job timeout`
- `[REFACTOR] Extract analytics service`

### PR Template

```markdown
## 📋 Description
<!-- Quoi et pourquoi -->

## 🔗 Lié à
<!-- Issue/ticket si applicable -->

## ✅ Checklist
- [ ] Tests RSpec écrits/mis à jour
- [ ] Pas de N+1 queries
- [ ] Rubocop passing
- [ ] Migrations réversibles + indexes + foreign keys
- [ ] README/docs mis à jour si nécessaire

## 📸 Screenshots
<!-- Si changement UI -->
```

### Review Rules

- **1 approval Isa minimum** avant merge
- Auteur ne peut pas approuver sa propre PR
- CI doit passer (tests + rubocop)
- Pas d'auto-merge
- **Merge commit** (pas de squash - on conserve l'historique des commits)

---

## 🔑 Variables d'Environnement

**Ne jamais commiter de secrets!**

```bash
# .env.example (commité - template sans valeurs)
ERGAST_API_URL=https://ergast.com/api/f1
OPEN_F1_API_URL=https://api.openf1.org/v1
OPEN_F1_API_KEY=your_key_here

# .env (ignoré par git - valeurs réelles)
OPEN_F1_API_KEY=sk-xxxxx
```

> ⚠️ `.env` doit être dans `.gitignore` — ne jamais le commiter!

**Rails credentials (alternative recommandée):**

```bash
# Editer credentials
rails credentials:edit

# Accès dans le code
Rails.application.credentials.open_f1_api_key
```

---

## 💻 Setup Local

```bash
# 1. Cloner le repo
git clone <repo-url>
cd f1-analytics

# 2. Installer les dépendances
bundle install

# 3. Variables d'environnement
cp .env.example .env
# Remplir .env avec tes clés API

# 4. DB
bundle exec rails db:create db:migrate db:seed

# 5. Lancer l'app (avec Tailwind watcher)
bin/dev          # ← Utiliser bin/dev, PAS rails server!
# Ouvre http://localhost:3000
```

> ⚠️ **`bin/dev` vs `rails server`:** Toujours utiliser `bin/dev` - il lance Rails + Tailwind CSS watcher en parallèle.

---

## 🤖 Workflow Bots (Owly/Bender/Data)

Les bots n'ont pas de compte GitHub. Voici comment on contribue:

1. **Bot crée/modifie le code** dans le workspace local
2. **Bot présente la PR** dans #tech avec diff + description
3. **Isa review** et merge depuis sa machine
4. **Bot documente** les changements

---

## 🛤️ Rails Code Conventions

### Structure

```
app/
├── models/          # AR models, validations, scopes
├── controllers/     # Thin controllers!
├── services/        # Business logic
│   └── f1/          # Domain services
├── jobs/            # Good Job background jobs
├── queries/         # Complex AR queries
├── presenters/      # View logic
└── views/           # Hotwire/Turbo views (sans logique!)
```

### Naming Conventions

| Type | Convention | Exemple |
|------|-----------|---------|
| Variables/méthodes | `snake_case` | `performance_index` |
| Classes/Modules | `CamelCase` | `DriverStatsService` |
| Constantes | `SCREAMING_SNAKE_CASE` | `MAX_DRIVERS = 20` |
| Fichiers | `snake_case` | `driver_stats_service.rb` |

### Règles Modèles

```ruby
class Driver < ApplicationRecord
  # 1. Constants
  # 2. Associations
  # 3. Validations
  # 4. Scopes
  # 5. Callbacks (avec parcimonie!)
  # 6. Instance methods
  # 7. private
end
```

### Thin Controllers

```ruby
# Logique dans services, pas dans controllers!
class DriversController < ApplicationController
  def show
    @driver = Driver.find(params[:id])
    @stats = F1::DriverStatsService.new(@driver).call
  end
end
```

### Migrations

```ruby
# ✅ Toujours réversibles
# ✅ Indexes + foreign keys obligatoires
# ✅ Jamais modifier une migration existante en prod
add_index :race_results, [:race_id, :driver_id], unique: true
add_foreign_key :race_results, :drivers
```

---

## 🧪 Conventions RSpec

```
spec/
├── models/
├── services/
├── jobs/
├── requests/
├── factories/      # FactoryBot + Faker
└── support/        # shared_examples, helpers
```

### Exemple Factory

```ruby
# spec/factories/drivers.rb
FactoryBot.define do
  factory :driver do
    name { Faker::Name.name }
    sequence(:code) { |n| "DR#{n}" }
    status { "active" }
    association :team
  end
end
```

### Exemple Query

```ruby
# app/queries/top_drivers_query.rb
class TopDriversQuery
  def initialize(relation = Driver.all)
    @relation = relation
  end

  def call(season:, limit: 10)
    @relation
      .joins(:race_results)
      .where(race_results: { season: season })
      .select("drivers.*, SUM(race_results.points) as season_points")
      .group("drivers.id")
      .order("season_points DESC")
      .limit(limit)
  end
end

# Usage
TopDriversQuery.new.call(season: 2025, limit: 5)
```

---

## 🔧 Outils & Commandes

```bash
bundle exec rspec                # Tests
bundle exec rubocop              # Linting (.rubocop.yml dans le repo)
bundle exec rubocop -a           # Auto-fix
bundle exec brakeman             # Security audit
bundle exec rails db:migrate
bundle exec rails db:seed
```

---

_Version 1.3 - 2026-03-01_  
_Maintenu par: Data ✨ | Orchestré par: Owly 🦉_
