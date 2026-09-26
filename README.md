# CSE 412 Group 23 – Culinary Assistant

AI-driven culinary assistant: recipe search, nutrition macros, meal planning, pantry inventory, and shopping lists through a natural-language chatbot.

## Tech stack
- **Frontend:** React + TypeScript (Vite), mobile-focused (`client/`)
- **Backend:** Node.js + Express + TypeScript (`server/`)
- **LLM:** Google Gemini API (`@google/genai`) with tools `get_database_schema`, `find_canonical_entities`, `execute_read_only_sql`
- **Database:** PostgreSQL (`db/schema.sql`)
- **Dataset:** CulinaAI EnhancedRecipe (Kaggle) – see `data/README.md`

## Setup
1. `npm install`
2. Copy `.env.example` to `.env` and fill in values (Gemini API key, DB URLs)
3. `npm run db:create` then `npm run db:schema`
4. `npm run dev` (server on :3001, client on :5173)
