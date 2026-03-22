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
- [ ] **[URGENT]** Migrer données 2025 → 2026 (saison active = 2026)
- [ ] **[URGENT]** Mettre à jour calendrier 2026 (24 → 22 courses: Bahrain + Saudi Arabia annulés)
- [ ] Seed pilotes/équipes 2026 (vérifier changements vs 2025)
- [ ] Seed résultats Chinese GP 2026 (Round 1 ou 2?) via OpenF1
- [ ] Seed grille départ qualifs China: Antonelli P1, Russell P2, Hamilton P3, Leclerc P4
- [ ] Job: FetchRaceResultsJob (auto post-course)
- [ ] Rake task: fetch résultats saison complète 2026

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

_Créé: 2026-03-01 | Mis à jour: 2026-03-15_

## 📰 News F1 2026 (2026-03-15)
- **Chinese GP Qualifs:** Antonelli pole (Mercedes, 19 ans — record historique !), Russell P2, Hamilton P3
- **Annulations:** Bahrain GP + Saudi Arabian GP annulés (conflit Moyen-Orient) → saison = 22 courses
- **Action:** Mettre à jour le seed calendrier + migrer app vers données 2026
