# WORKFLOW.md — F1 Analytics 🏎️
> Protocole officiel de collaboration inter-agents.
> Maintenu par Data ✨ | Orchestré par Owly 🦉 | Supervisé par Isa

---

## Vue d'ensemble

```
Owly prend un ticket
    ↓
Selon le type de ticket :
    ├── Design impliqué ?  → Iris d'abord
    ├── Texte UI/copy ?    → Colette d'abord
    └── Code pur ?         → Bender directement
    ↓
Bender implémente
    ↓
Data review code
    ↓
Data OK → Owly push + PR
    ↓
CI vert → Owly merge (feature → develop)
    ↓
Owly notifie Isa (résumé)
    ↓
Isa valide develop → main (prod)
```

---

## Phases détaillées

### Phase 1 — Brief Owly

Owly lit le ticket et détermine les agents impliqués.

**Critères :**
- Nouveau composant visuel / page → Iris obligatoire
- Texte dans l'UI (labels, messages, tooltips, emails) → Colette obligatoire
- Migration / service / job / model → Bender directement
- En cas de doute → Iris + Colette avant Bender (moins coûteux de corriger un spec qu'un code)

Owly dépose le brief dans l'inbox des agents concernés avec :
- Description du ticket
- Ce qui est attendu de chaque agent
- Dépendances (ex: "Bender attend le spec Iris avant de commencer")

---

### Phase 2a — Iris (si design impliqué)

Iris produit un spec visuel dans `/shared/f1-analytics/specs/design/[ticket]-iris.md` :
- Composants concernés
- Layout / structure
- États (vide, chargement, erreur, succès)
- Interactions (hover, click, responsive)
- Couleurs / typographie si déviation du système existant

**Aller-retour Iris ↔ Owly :**
- Max 2 cycles de révision avant escalade à Isa
- Si Bender implémente et le rendu ne correspond pas → Bender décrit le problème précisément à Owly → Owly rebrief Iris avec screenshot/description → Iris produit un spec corrigé → Bender réimplémente
- **Jamais** Bender ne corrige le design de sa propre initiative sans spec Iris

---

### Phase 2b — Colette (si copy impliqué)

Colette produit les textes dans `/shared/f1-analytics/specs/copy/[ticket]-colette.md` :
- Tous les strings UI concernés (labels, boutons, messages d'erreur, tooltips, emails)
- Contexte de chaque texte (où il apparaît, à qui)
- Variantes si nécessaire (pluriel, états)

**Aller-retour Colette ↔ Owly :**
- Si après intégration un texte est trop long / mal adapté à l'UI → Bender signale à Owly avec capture + contrainte technique → Owly rebrief Colette → Colette révise → Bender met à jour
- Max 2 cycles avant escalade à Isa
- **Jamais** Bender ne réécrit le copy de sa propre initiative

---

### Phase 3 — Bender implémente

Bender reçoit le brief Owly + specs Iris/Colette le cas échéant.

**Règles :**
- Commence seulement quand tous les specs attendus sont disponibles
- Si un spec est ambigu → demande clarification à Owly **avant** de coder (pas après)
- Livre le code dans `/shared/f1-analytics/` avec un message clair à Owly

**Checklist Bender avant de passer à Data :**
- [ ] Tests RSpec écrits/mis à jour
- [ ] Pas de N+1 queries
- [ ] RuboCop passing (`bundle exec rubocop`)
- [ ] Migrations réversibles + indexes + foreign keys
- [ ] Pas de commentaires laissés dans le code
- [ ] Specs Iris/Colette respectées (si applicables)
- [ ] Description claire du changement pour Data

---

### Phase 4 — Data review

Data reçoit la notification d'Owly avec le lien vers le code.

Data lit le code et vérifie :

**Architecture & conventions**
- [ ] Thin controllers, logique dans services
- [ ] Conventions de nommage (snake_case, CamelCase, SCREAMING_SNAKE_CASE)
- [ ] Ordre dans les modèles (constants → associations → validations → scopes → callbacks → methods → private)
- [ ] Pas de logique dans les vues

**Qualité**
- [ ] Edge cases couverts
- [ ] Tests présents et pertinents (pas juste du happy path)
- [ ] Pas de N+1 queries
- [ ] Migrations réversibles

**Sécurité**
- [ ] Pas de secrets dans le code
- [ ] Pas de données sensibles exposées dans les vues/JSON

**Si tout est OK → Data envoie "OK merge" à Owly**
**Si problème → Data liste les points précis à corriger → Owly rebrief Bender**

**Aller-retour Data ↔ Bender :**
- Max 2 cycles de révision
- Si après 2 cycles le problème persiste → escalade à Isa
- Data ne corrige pas le code de Bender directement — elle pointe, Bender corrige

---

### Phase 5 — Owly push & PR

Owly reçoit le "OK merge" de Data.

```bash
git checkout develop
git pull origin develop
git checkout -b feature/[ticket-slug]
# applique les fichiers de /shared/f1-analytics/
git add .
git commit -m "feat(scope): description

Co-authored-by: Bender 🤖 <bender@f1-analytics.local>
Committed-by: Owly 🦉 <owly@f1-analytics.local>
Model: claude-sonnet-4-6 (Anthropic)"
git push origin feature/[ticket-slug]
# ouvre PR feature → develop sur GitHub
```

**PR description minimale :**
- Ce que ça fait (1-2 phrases)
- Agents impliqués (Iris/Colette/Bender/Data)
- Lien ticket si applicable
- Screenshots si changement UI

---

### Phase 6 — CI + merge develop

- CI doit être vert (RSpec + RuboCop)
- Si CI rouge → Owly notifie Bender avec le log d'erreur → Bender corrige → nouveau push
- CI vert → **Owly merge** feature → develop
- Owly notifie Isa sur Discord : résumé en 2-3 lignes de ce qui a été mergé

---

### Phase 7 — Isa valide → prod

- Isa review develop quand elle le souhaite
- PR develop → main : **Isa obligatoire**
- Merge = déploiement prod automatique (Fly.io)

---

## Règles générales

**Escalade à Isa si :**
- Plus de 2 cycles de révision sur n'importe quelle phase
- Désaccord entre agents sur une décision d'architecture
- Bug en prod
- CI rouge depuis plus de 24h
- Ambiguité sur le scope d'un ticket

**Jamais :**
- ❌ Push direct sur `develop` ou `main`
- ❌ Bender corrige un design sans spec Iris
- ❌ Bender réécrit du copy sans Colette
- ❌ Data corrige le code de Bender directement
- ❌ Owly merge sans CI vert + Data OK

**PRs avec dépendances :**
Préfixer le titre avec `[after #XX]` — Owly respecte l'ordre de merge.

---

## Fichiers de specs

```
/shared/f1-analytics/specs/
├── design/     # Specs visuelles Iris — [ticket]-iris.md
└── copy/       # Textes UI Colette — [ticket]-colette.md
```

---

_WORKFLOW.md v1.0 — 2026-04-01 — Data ✨_
_À mettre à jour si le process évolue. Toute exception = décision Isa._
