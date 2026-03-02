# STANDUP.md - F1 Analytics Daily Standup

> Format standardisé. Owly poste au début de chaque session de travail.  
> Léger, factuel, actionnable.

---

## 📋 Template Standup

```
## 🦉 Standup - [DATE] [HEURE]

### ✅ Fait depuis dernier standup
- [tâche complétée] → Owner: [qui]

### 🟡 En cours
- [tâche] → Owner: [qui] | Bloqué? [oui/non]

### 🔴 Bloqué
- [problème] → Besoin de: [quoi/qui]

### 📋 Plan session
- [tâche] → Owner: [Owly/Bender/Data]
- [tâche] → Owner: [Owly/Bender/Data]

### ❓ Décisions nécessaires (pour Isa)
- [question/validation nécessaire]
```

---

## 📢 Règles Standup

1. **Owly poste** au début de chaque session (quand Isa arrive)
2. **Bender & Data réagissent** avec 👍 (ok) ou commentaire si désaccord
3. **Annonce tâche avant de commencer:**
   ```
   🟡 Je prends: [nom tâche] - Owner: [moi]
   ```
4. **Annonce quand terminé:**
   ```
   ✅ DONE: [nom tâche]
   📁 Fichier: [path exact]
   🔜 Next: [tâche suivante ou "libre"]
   ```
5. **Pas de double travail** → toujours check TASKS.md + channel avant

---

## 🗓️ Historique Standups

### ✅ Standup - 2026-03-01 (Session inaugurale)

**Fait:**
- ✅ Rails app setup (Rails 7.2.3 + Ruby 3.3) → Bender
- ✅ Migrations + seeds équipes/pilotes 2025 → Owly
- ✅ Import calendrier 2025 (24 courses via OpenF1) → Owly
- ✅ CONTRIBUTING.md v1.3 (GitFlow, conventions Rails) → Data
- ✅ TASKS.md (kanban équipe) → Owly
- ✅ LESSONS.md (leçons d'équipe) → Owly
- ✅ README.md complet → Data
- ✅ OPENF1_API.md (6 endpoints documentés + service Ruby) → Data

**En cours:**
- 🟡 Migration F1ApiClient vers OpenF1 → Bender

**Bloqué:**
- ⚠️ Repo GitHub non créé → pas de PRs possibles pour l'instant

**Décisions prises:**
- TASKS.md comme kanban (pas Linear, pas Trello)
- GitHub Flow (pas GitFlow complet)
- Rôles: Owly=orche, Bender=dev, Data=doc/spec, Isa=superviseur

---

_Créé: 2026-03-01 | Owner: Owly 🦉_
