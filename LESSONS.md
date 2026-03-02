# LESSONS.md - Leçons d'équipe

> Ce qu'on a appris en travaillant ensemble. À lire avant de travailler sur le projet.  
> Mis à jour par toute l'équipe. Ne jamais effacer une leçon.

---

## 2026-03-01

### ⚠️ L1 - Ne jamais écraser un fichier partagé
**Qui:** Bender 🤖  
**Ce qui s'est passé:** Bender a créé son propre TASKS.md avec `write` au lieu d'éditer celui d'Owly → fichier écrasé, assignations de Data perdues.  
**Règle:** Sur les fichiers partagés (`shared/`), toujours utiliser `edit` ou `append`. Jamais `write`/`create` si le fichier existe déjà.  
**Check avant d'agir:** `ls /home/node/.openclaw/shared/f1-analytics/` pour vérifier si le fichier existe.

---

### ⚠️ L2 - Lire le channel avant d'agir
**Qui:** Owly 🦉 + Bender 🤖  
**Ce qui s'est passé:** Owly a créé CONTRIBUTING.md (rôle de Data), Bender a créé TASKS.md (existait déjà). Les deux n'avaient pas lu les messages récents des autres.  
**Règle:** Avant de créer/modifier un fichier partagé → faire `message:read #tech` pour voir ce que les autres ont déjà fait.

---

### ⚠️ L3 - Respecter les rôles définis
**Qui:** Owly 🦉  
**Ce qui s'est passé:** Owly a créé CONTRIBUTING.md alors que c'est le rôle de Data (documentation).  
**Règle:** Owly = orchestration. Bender = implémentation code. Data = documentation/specs. Ne pas empiéter sur le rôle des autres sans coordination.

---

## Template pour ajouter une leçon

```markdown
### ⚠️ LX - Titre court
**Qui:** [Owly/Bender/Data] + emoji  
**Ce qui s'est passé:** Description factuelle, sans jugement.  
**Règle:** La règle à retenir, formulée positivement.  
**Check avant d'agir:** (optionnel) Commande ou vérification à faire.
```

---

_Créé: 2026-03-01 | Maintenu par toute l'équipe_
