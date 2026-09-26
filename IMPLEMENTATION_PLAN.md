# Implementation Plan

Next steps for the CSE 412 Group 23 Culinary Assistant, following the Phase 1 proposal. The scaffold (client, server, stubs, draft `db/schema.sql`) is in place; nothing below has been implemented yet.

## Phase 0 – Environment & decisions
- [ ] Agree on Postgres credentials and create `.env` from `.env.example` (never commit it).
- [ ] Get a Gemini API key and confirm the model name in `GEMINI_MODEL`.
- [ ] Download the CulinaAI EnhancedRecipe dataset from Kaggle into `data/` (git-ignored).
- [ ] Inspect the dataset's actual columns, sizes, and quality (nulls, duplicates, nutrition confidence) before finalizing the schema.
- [ ] Decide on user handling: real auth vs. a single demo user (recommended for a class project: demo user selected by id).

## Phase 1 – Database
- [ ] Finalize `db/schema.sql` against the real dataset columns (ER diagram: users, recipes, ratings, basket_products, user_inventory, shopping_lists, contains).
- [ ] Decide whether to normalize ingredients (a `recipe_ingredients` table with quantity/unit) instead of `TEXT[]`; needed for scaling and unit conversion.
- [ ] Create the `culinary` database and apply the schema.
- [ ] Create the read-only role (`culinary_ro`) with SELECT-only grants.
- [ ] Add indexes for expected queries: `energy_kcal_per_serving`, `meal_type`, GIN on `ingredients`/`ner`, and `pg_trgm` or full-text search on `title`.
- [ ] Add seed data for a demo user, inventory, and shopping list.

## Phase 2 – Data import
- [ ] Write the import script in `scripts/` (CSV/JSON → Postgres) with batching (`COPY` or multi-row inserts).
- [ ] Clean and normalize: trim strings, parse ingredient/NER lists, coerce numeric nutrition fields, drop unusable rows.
- [ ] Make it idempotent and re-runnable; log row counts and rejects.
- [ ] Import `basket_products` data if included in the dataset.
- [ ] Add an `npm run db:import` script and document it in the README.
- [ ] Sanity-check with spot queries (row counts, sample recipes, nutrition ranges).

## Phase 3 – Agent tools (server)
Implement in `server/src/tools/`, each with a `zod` input schema.
- [ ] `get_database_schema()` – query `information_schema` (tables, columns, types, FKs) and return a compact description, optionally with column notes and sample values.
- [ ] `find_canonical_entities(terms)` – map slang/typos/broad terms ("high protein", "chicken", "dinner") to real values: exact/trigram matching against `meal_type`, classifications, and ingredient/NER vocabulary, plus a small synonym map for macro terms; return IDs/values and confidence.
- [ ] `execute_read_only_sql(sql)` – safety layers:
  - connect via `readOnlyPool` (SELECT-only role)
  - run in a `READ ONLY` transaction with `statement_timeout`
  - allow a single statement that starts with `SELECT`/`WITH`; reject everything else
  - enforce a `LIMIT` cap and result size cap
  - return rows as JSON, or a clear error the LLM can use to retry
- [ ] Unit tests for each tool, especially SQL rejection cases (`DROP`, multi-statement, comments, `;`).

## Phase 4 – LLM agent
- [ ] Declare the three tools as Gemini function declarations in `server/src/llm/agent.ts`.
- [ ] Implement the loop: send prompt → execute requested tool calls → feed results back → repeat until a final text answer (with a max-iterations guard).
- [ ] Write the system prompt: role, dialect (PostgreSQL), rule to call `get_database_schema` first, rule to resolve terms via `find_canonical_entities`, read-only only, response style.
- [ ] Support conversation history so follow-ups ("make this recipe for 2x") work.
- [ ] Handle errors gracefully (SQL error retry, Gemini rate limits/timeouts).
- [ ] Log tool calls and generated SQL for debugging.
- [ ] Wire up `POST /api/chat` in `server/src/routes/chat.ts` (validate body, call agent, return message plus structured results such as recipes).

## Phase 5 – Non-chat features
These are the proposal's core features beyond querying; decide which run through the LLM and which are plain endpoints.
- [ ] **Macro calculator** – compute totals/per-serving nutrition for a recipe or meal plan.
- [ ] **Scaling & unit conversion** – deterministic code (not LLM math) for "scale by 2.5" and "cups to grams"; needs parsed quantities/units (see Phase 1).
- [ ] **Pantry inventory** – CRUD endpoints for `user_inventory`; "what can I make with what I have" query (ingredient overlap ranking).
- [ ] **Shopping list** – generate from a recipe or meal plan, subtract pantry items, map to `basket_products`; CRUD for lists.
- [ ] **Meal calendar** – weekly plan storage (may need a `meal_plan` table not in the ER diagram).
- [ ] **User-submitted recipes** – insert endpoint with validation.
- [ ] **Ratings** – create/read ratings per recipe.
- [ ] **Dietary restrictions** – filter by restriction (vegetarian, allergens, etc.) via canonical entity lookup; consider storing restrictions per user.

The write endpoints use the read/write pool. Only the LLM tool uses the read-only pool.

## Phase 6 – Frontend (React, mobile-first)
- [ ] App shell and routing (`react-router-dom`): Chat, Recipes, Pantry, Shopping List, Meal Plan.
- [ ] Chat screen: message list, input box, loading state, error state.
- [ ] Recipe card/detail components (image, macros, ingredients, instructions).
- [ ] API client module and shared types between client and server.
- [ ] Pantry, shopping list, and calendar screens.
- [ ] Responsive/mobile styling and basic accessibility (labels, contrast, keyboard use).

## Phase 7 – Testing & polish
- [ ] Test each example prompt from the proposal end-to-end ("Show me what I can make with what I have at home", "Find me an easy recipe with ground beef under 500cal", "Scale all of the ingredients in this recipe by 2.5", etc.).
- [ ] Adversarial tests: prompt-injection attempts to write/drop data, malformed SQL, empty results.
- [ ] Error handling and empty-state UX.
- [ ] Update the README (setup, env vars, import steps) and finalize docs for submission.
- [ ] Prepare the demo.

## Suggested order & split
1. Phases 0–2 first (everything depends on real data in Postgres).
2. Phases 3–4 (core agent) in parallel with the Phase 6 chat UI once `/api/chat` is stubbed with fixed responses.
3. Phase 5 features in priority order: pantry → shopping list → scaling/conversion → calendar → the rest.
4. Phase 7 throughout, with a final pass before the deadline.

## Open questions
- Does the dataset include parsed ingredient quantities/units, or only raw ingredient strings?
- Auth: is a demo user enough?
- Where will the app be hosted for the demo (local only vs. deployed)?
