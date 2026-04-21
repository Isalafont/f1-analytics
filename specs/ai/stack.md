# AI Stack — F1 Analytics (Work In Progress)

## 1. Situations clés
- Backend Rails 8.1 + Ruby 3.4.7 (SQLite3, Turbo, Stimulus, Propshaft) : stack classique, prêt pour une couche IA légère.
- Pas de code IA existant dans le repo : il faut l’introduire proprement (services, jobs, UI, tests, observabilité).
- Les agents OpenClaw (Bender/Isa/Owly…) orchestrent déjà le repo via inbox/briefs. On peut tirer parti de ce workflow pour lier Rails → IA (planification + exécution). 

## 2. Veille IA & sources (minimum 5 articles)
1. **Rubyroid Labs — "AI agents in Ruby on Rails" (avr. 2026)**
   - Vision alignée sur nos besoins : agents qui orchestrent plusieurs jobs/test/DB calls et respectent les règles de sécurité. Le modèle recommandé : OpenAI/Mistral/Gemini via tools + functions pattern.
   - Propositions concrètes pour Rails : service `SupportAgent`, module `OpenaiToolable`, boundary JSON schema, isolation des actions dans les services.

2. **Simon Willison — "Introducing Mistral Small 4" (16 mars 2026)**
   - Mistral Small 4 unifie reasoning/multimodal/coding, reasoning_effort réglable, modèle open Apache 2 (119B). Permet de couvrir reasoning + génération de code -> bon candidat pour nos agents travailleur de code.
   - Documentation mentionne API ajustable (`reasoning_effort`), utile pour séparer prompts courts (tests) vs prompts de stratégie (planification). On peut aussi self-host si on veut rester offline pour prod.

3. **Mohtaweb — "Integrating Gemini AI API into Web Applications" (avril 2026)**
   - Explique la partie observabilité & sécurité : system prompts, safety settings, limites de débit, monitoring latency/errors.
   - Recommandation : backend gère clés/secrets (pas le JS), log des responses, bande passante pour éviter XY injection. C’est exactement notre cas avec Fly secrets + Turbo Streams.

4. **OpenAI Docs — "Using GPT-5.4" (Avril 2026)**
   - Nouveau contexte 1M tokens, pricing tiers, standard vs priority processing, très utile pour notre service qui aura du prompt long (résumés de courses). Il faut limiter la taille des prompts en amont via `AiInsightService`.
   - Best practice : valider les réponses (checksums) et découper les données (feuilles de course) pour éviter le token explosion.

5. **LaoZhang AI Blog — "Complete Gemini Image API Guide 2026" (16 mars 2026)**
   - Focus observabilité : streaming, pricing, relais, et exemples d’intégration (payload JSON de la requête). Même si on n’utilise pas l’image, la partie `relay` est utile pour éviter les limites d’accès (Gemini Enterprise). 
   - On peut s’inspirer des patterns d’observabilité (latence/cost) pour `GEMINI_API` dans notre config.

## 3. Architecture proposée
### 3.1 Service Rails `AiInsightService`
- `call(context:, intent:, model:)` → construit prompt (resume les `RaceResult`, `Team` performances, etc.)
- Supports : `:openai`, `:mistral`, `:gemini`. Chaque modèle possède un `Adapter` qui gère : endpoint, headers, timeout (3s), max tokens (quarter of context length).
- `config/ai.yml` ou `dry-configurable` pour toutes les clés/urls + fallback.
- Ouvre un `AiInsight` ActiveRecord (model + table) : columns `:context_snapshot`, `:model_used`, `:prompt`, `:response_summary`, `:status`, `:error_message`, `:created_at`.

### 3.2 Job `GenerateAiSummaryJob`
- Maus: triggered after `CalculateMetricsJob` (via event broadcast). Récupère les derniers `RaceResult` et `TeamMetric`, appelle `AiInsightService`, stocke la réponse.
- Timeout/rescue : quand `OpenAI::Error` ou `Net::ReadTimeout`, log (NewRelic style) + `AiInsight.create!(status: :failed, error_message: e.message)`.
- Utilisateurs (Isa) reçoivent la dernière `AiInsight` via Turbo Stream component `/dashboard/ai_insights`. 
- Fallback plan : en cas de fail, on envoie les données à `AiFallbackChannel` (Stimulus) pour suggérer un prompt plus court.

### 3.3 UI + API
- Stimulus controller `AiInsightController` : gère le bouton `Demander un insight IA`, spinner, error handling, chargement Turbo Stream.
- Endpoint Rails `AiInsightsController` (namespace `Api::V1` pour l’UI). `create` → `GenerateAiSummaryJob.perform_later(...)`, `index` → liste des `AiInsight` (décorée). 
- Panel `app/views/dashboard/_ai_insights.html.erb` show cards (status, source, summary, actions). 
- Stimulus + Turbo se chargent du refresh du panel.

### 3.4 Observabilité & sécurité
- Env vars via Fly secrets (`fly secrets set OPENAI_KEY=xxx`, `GEMINI_KEY`, `MISTRAL_KEY`). `config/initializers/ai.rb` valide leur présence (raise si en prod et missing).
- Tests : RSpec coverage for `AiInsightService` + job, mocking adapters (VCR not available due to network). Utiliser `webmock` stubs.
- Logging : `AiInsightService` triggers `ActiveSupport::Notifications.instrument(