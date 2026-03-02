# OpenF1 API - Documentation pour F1 Analytics 🏎️

> Documenté par Data ✨ | Testé en live le 2026-03-01  
> Base URL: `https://api.openf1.org/v1`  
> Doc officielle: <https://openf1.org>

---

## 📋 Informations Générales

- **Auth:** Aucune (pas de clé API requise!)
- **Format:** JSON (défaut) ou CSV (`?csv=true`)
- **Rate limits:** 3 req/s, 30 req/min (gratuit)
- **Historique:** Données disponibles depuis **2023**
- **Délai live:** ~3 secondes après les événements réels

---

## 🔑 Concepts Clés

### session_key
Identifiant unique d'une session (course, qualifs, essais).
```
session_key=9693  → Race Australie 2025
session_key=9998  → Race Chine 2025
session_key=10006 → Race Japon 2025
```

### meeting_key
Identifiant du Grand Prix (weekend complet).

### driver_number
Numéro officiel du pilote (ex: 1=Verstappen, 44=Hamilton, 16=Leclerc).

---

## 🎯 Endpoints Utiles pour F1 Analytics

### 1. Sessions (⭐ Point d'entrée principal)

```bash
GET /v1/sessions
```

**Paramètres utiles:**
- `year` - Saison (ex: 2025)
- `session_type` - "Race", "Qualifying", "Practice"
- `session_name` - "Race", "Qualifying", "Sprint"

**Exemple - Toutes les courses 2025:**
```bash
curl "https://api.openf1.org/v1/sessions?year=2025&session_name=Race"
```

**Réponse:**
```json
{
  "session_key": 9693,
  "session_type": "Race",
  "session_name": "Race",
  "date_start": "2025-03-16T04:00:00+00:00",
  "date_end": "2025-03-16T06:00:00+00:00",
  "meeting_key": 1254,
  "circuit_short_name": "Melbourne",
  "country_name": "Australia",
  "location": "Melbourne",
  "year": 2025
}
```

**Courses 2025 confirmées (races passées):**
| Round | session_key | Circuit | Date |
|-------|-------------|---------|------|
| 1 | 9693 | Melbourne (AUS) | 2025-03-16 |
| 2 | 9998 | Shanghai (CHN) | 2025-03-23 |
| 3 | 10006 | Suzuka (JPN) | 2025-04-06 |
| 4 | 10014 | Sakhir (BRN) | 2025-04-13 |
| 5 | 10022 | Jeddah (KSA) | 2025-04-20 |
| 6 | 10033 | Miami (USA) | 2025-05-04 |

---

### 2. Positions (classement en course)

```bash
GET /v1/position
```

**Paramètres:**
- `session_key` - Session concernée
- `driver_number` - Numéro pilote (optionnel)

**Exemple:**
```bash
curl "https://api.openf1.org/v1/position?session_key=9693&driver_number=1"
```

**Réponse:**
```json
{
  "date": "2025-03-16T05:36:40.897000+00:00",
  "session_key": 9693,
  "meeting_key": 1254,
  "driver_number": 1,
  "position": 1
}
```

**Usage pour nos métriques:**
- `Race Pace` = positions gagnées (position_depart - position_finale)
- Historique positions = graphique évolution en course

---

### 3. Laps (données par tour)

```bash
GET /v1/laps
```

**Paramètres:**
- `session_key`
- `driver_number`
- `lap_number`

**Exemple:**
```bash
curl "https://api.openf1.org/v1/laps?session_key=9693&driver_number=1"
```

**Réponse:**
```json
{
  "session_key": 9693,
  "driver_number": 1,
  "lap_number": 1,
  "date_start": "2025-03-16T04:18:22.973000+00:00",
  "duration_sector_1": 43.749,
  "duration_sector_2": 20.705,
  "duration_sector_3": 55.25,
  "lap_duration": 119.704,
  "i1_speed": 249,
  "i2_speed": 292,
  "st_speed": 215,
  "is_pit_out_lap": false
}
```

**Usage pour nos métriques:**
- `Consistency Score` = variance des `lap_duration`
- Détection pits: `is_pit_out_lap`

---

### 4. Drivers (pilotes)

```bash
GET /v1/drivers
```

**Exemple:**
```bash
curl "https://api.openf1.org/v1/drivers?session_key=9693"
```

**Réponse:**
```json
{
  "driver_number": 1,
  "full_name": "Max VERSTAPPEN",
  "name_acronym": "VER",
  "team_name": "Red Bull Racing",
  "team_colour": "3671C6",
  "first_name": "Max",
  "last_name": "Verstappen",
  "headshot_url": "https://...",
  "country_code": "NED"
}
```

---

### 5. Pit Stops

```bash
GET /v1/pit
```

**Paramètres:**
- `session_key`
- `driver_number`

**Exemple:**
```bash
curl "https://api.openf1.org/v1/pit?session_key=9693&driver_number=1"
```

**Réponse:**
```json
{
  "session_key": 9693,
  "driver_number": 1,
  "lap_number": 23,
  "pit_duration": 2.4,
  "date": "2025-03-16T04:55:00+00:00"
}
```

---

### 6. Weather (météo)

```bash
GET /v1/weather
```

**Réponse:**
```json
{
  "session_key": 9693,
  "air_temperature": 28.4,
  "track_temperature": 45.2,
  "humidity": 52.0,
  "wind_speed": 2.1,
  "rainfall": false
}
```

---

### 7. Race Control (drapeaux, SC, VSC)

```bash
GET /v1/race_control
```

**Réponse:**
```json
{
  "session_key": 9693,
  "category": "Flag",
  "flag": "YELLOW",
  "message": "YELLOW IN TURN 4",
  "date": "2025-03-16T04:30:00+00:00"
}
```

---

## 🏗️ Mapping vers nos Modèles Rails

### Comment récupérer un résultat de course complet

```ruby
# 1. Trouver la session_key de la course
GET /v1/sessions?year=2025&session_name=Race&circuit_short_name=Melbourne
# → session_key: 9693

# 2. Position de départ (qualifs)
GET /v1/position?session_key=QUALIF_KEY&driver_number=1
# → position de départ

# 3. Position finale (dernière position en race)
GET /v1/position?session_key=9693&driver_number=1
# → prendre la dernière entrée = position finale

# 4. Tours pour consistency score
GET /v1/laps?session_key=9693&driver_number=1
# → calculer variance des lap_duration (sans pits)

# 5. Pits stops (pour fiabilité)
GET /v1/pit?session_key=9693&driver_number=1
```

### Calcul Performance Index

```ruby
# Performance Index = (points obtenus / points max possibles) * fiabilité
# fiabilité = 1 si DNF = 0, sinon 1

points_map = {1=>25, 2=>18, 3=>15, 4=>12, 5=>10, 6=>8, 7=>6, 8=>4, 9=>2, 10=>1}
position_finale = positions.last[:position]
points = points_map[position_finale] || 0
```

### Calcul Race Pace (positions gagnées)

```ruby
# Race Pace = position_depart - position_finale
# Positif = a gagné des positions, Négatif = a reculé
race_pace = position_depart - position_finale
```

---

## 🚫 Limites à Connaître

1. **Pas de points officiels** → on les calcule nous-mêmes depuis les positions
2. **Pas de standings officiels** → calculer depuis nos race_results
3. **Données depuis 2023 seulement**
4. **Sprint weekends** → session_type="Sprint" (différent de "Race")
5. **Qualification** → session_name="Qualifying" pour position de départ

---

## 💎 Endpoints Bonus (V2+)

```bash
# Telemetrie (V2 - optionnel)
GET /v1/car_data?session_key=9693&driver_number=1
# → speed, throttle, brake, rpm, gear

# Team Radio (fun mais pas utile pour métriques)
GET /v1/team_radio?session_key=9693&driver_number=1
```

---

## 🔧 Service Ruby Recommandé

```ruby
# app/services/f1/open_f1_client.rb
module F1
  class OpenF1Client
    BASE_URL = "https://api.openf1.org/v1".freeze

    def sessions(year:, session_name: "Race")
      get("/sessions", year: year, session_name: session_name)
    end

    def positions(session_key:, driver_number: nil)
      params = { session_key: session_key }
      params[:driver_number] = driver_number if driver_number
      get("/position", **params)
    end

    def laps(session_key:, driver_number:)
      get("/laps", session_key: session_key, driver_number: driver_number)
    end

    def pit_stops(session_key:, driver_number:)
      get("/pit", session_key: session_key, driver_number: driver_number)
    end

    def drivers(session_key:)
      get("/drivers", session_key: session_key)
    end

    private

    def get(endpoint, **params)
      uri = URI("#{BASE_URL}#{endpoint}")
      uri.query = URI.encode_www_form(params)
      response = Net::HTTP.get_response(uri)
      JSON.parse(response.body)
    rescue => e
      Rails.logger.error "OpenF1 API error: #{e.message}"
      []
    end
  end
end
```

---

_Documenté par: Data ✨ | 2026-03-01_  
_Testé avec les vraies données races 2025_
