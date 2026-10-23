# CSE 412 Group 23 – Culinary Assistant

AI-driven culinary assistant: recipe search, nutrition macros, meal planning, pantry inventory, and shopping lists through a natural-language chatbot.

## Tech stack
- **Frontend:** React + TypeScript (Vite), mobile-focused (`client/`)
- **Backend:** Node.js + Express + TypeScript (`server/`)
- **LLM:** Google Gemini API (`@google/genai`) with tools `get_database_schema`, `find_canonical_entities`, `execute_read_only_sql`
- **Database:** PostgreSQL (`db/schema.sql`)
- **Dataset:** CulinaAI EnhancedRecipe (Kaggle) – see `data/README.md`

## Setup

> The database lives in the PostgreSQL server on **your own machine** — it is not
> stored in Git. Cloning the repo gives you the schema and scripts, not the data.
> **Every collaborator runs these steps locally.** These assume the class
> PostgreSQL setup (the course "PostgreSQL Setup" page): trust auth, no password,
> your chosen `PGPORT`, `psql`/`createdb` on your `PATH`.

**1. Start your Postgres server** (the one from the class setup):
```bash
export PGPORT=8888        # the port you chose
export PGHOST=/tmp        # macOS/Linux socket dir; omit on Windows
pg_ctl -D $HOME/db412 -o '-k /tmp' start
```

**2. Install deps and configure env:**
```bash
npm install
cp .env.example .env      # then set PGPORT in the DATABASE_URL(s) to match step 1
```

**3. Create the database, tables, and demo rows** — one command:
```bash
npm run db:setup          # = db:create + db:schema + db:seed
```

**4. Load the recipe dataset** (~1.02M rows; not in Git — see `data/README.md`):
```bash
# download via kagglehub, then clean the raw CSV into Postgres-ready form:
python scripts/clean_recipes.py "<dataset-path>/1M_Final.csv" data/recipes_clean.csv
# copy the basket file in alongside it:
cp "<dataset-path>/Basket_Products.csv" data/basket_products.csv
# import both (recipes + deduped basket products):
npm run db:import
```
The cleaner converts the raw CSV's Python-list `ingredients`/`NER` into Postgres
array literals and normalizes numeric columns; `db/import.sql` does the `COPY`s.

**5. Run it:**
```bash
npm run dev               # server on :3001, client on :5173
```

> The dataset is ~1.4 GB (over GitHub's limit), so the raw and cleaned CSVs stay
> git-ignored in `data/`. Each collaborator downloads and imports locally. Start
> your Postgres server (step 1) at the beginning of each session.
