# TASKS.md - F1 Analytics

> Kanban text-based. Mis à jour en temps réel.  
> Owner: Owly 🦉 | Superviseur: Isa

---

## 🔴 Backlog

### Dashboard
- [ ] Implémenter driver standings (classement points)
- [ ] Implémenter constructor standings (classement écuries)
- [ ] Fetch et afficher résultats dernières courses
- [ ] Page détail pilote (stats + métriques custom)
- [ ] Page détail écurie

### Métriques Custom
- [ ] Implémenter Performance Index (points pondérés fiabilité)
- [ ] Implémenter Consistency Score (variance résultats)
- [ ] Implémenter Race Pace (positions gagnées grid→finish)
- [ ] Implémenter Quali Pace (grille moyenne)
- [ ] Implémenter Recent Form (rolling avg 3 dernières courses)
- [ ] Job: CalculateMetricsJob (après chaque race)

### API & Data
- [x] Migrer F1ApiClient vers OpenF1 (Ergast est mort) (Owner: Bender 🤖 | Done: 2026-03-01 ✅)
- [ ] Job: FetchRaceResultsJob (auto post-course)
- [ ] Rake task: fetch résultats saison complète 2025
- [ ] Seed résultats des courses déjà passées (round 1-3)

### UI/UX
- [ ] Layout dashboard dark theme F1 (#1a1a1a + rouge #e10600)
- [ ] Charts pilotes (Chart.js) - évolution points sur saison
- [ ] Responsive mobile
- [ ] Tailwind CSS finalisé

### Tests
- [ ] Specs models (Driver, Race, Result, Metric)
- [ ] Specs services (F1ApiClient, MetricsCalculator)
- [ ] Specs jobs (FetchRaceResults, CalculateMetrics)

### CI/CD & Setup
- [ ] Créer repo GitHub
- [ ] Setup GitHub Actions (rspec + rubocop + brakeman)
- [ ] Ajouter .env.example
- [ ] Compléter README (setup local, architecture) (Owner: Data)

---

## 🟡 In Progress

- [x] Documentation OpenF1 API → Data ✨ ✅ (OPENF1_API.md dans shared/)
- [x] README complet setup local + architecture → Data ✨ ✅ (README.md dans shared/)

---

## ✅ Done

- [x] Rails app setup (Rails 7.2.3 + Ruby 3.3)
- [x] Stack: SQLite3 + Tailwind + Propshaft + Turbo/Stimulus + RSpec
- [x] Migrations (teams, drivers, races, results, metrics, weather, news)
- [x] Seeds équipes + pilotes 2025 (10 teams, 20 drivers)
- [x] Import calendrier 2025 via OpenF1 API (24 courses)
- [x] CONTRIBUTING.md v1.3 (GitFlow, commits, PR, conventions Rails) ✨ Data
- [x] Définition rôles équipe (Owly orche, Bender dev, Data doc/spec)

---

## 📋 Règles

- **Owly** crée et priorise les tâches
- **Bender** implémente le code (update statut → 🟡 quand il prend)
- **Data** documente et écrit les specs (update statut → 🟡 quand il prend)
- **Owly** consolide et soumet à Isa avant merge
- **Isa** valide et merge (décision finale)
- **⚠️ Ne jamais écraser le fichier - toujours éditer!**

Format d'une tâche In Progress:
```
- [ ] Nom tâche (Owner: Bender | Started: 2026-03-01)
```

---

_Créé: 2026-03-01 | Mis à jour: 2026-03-01_
