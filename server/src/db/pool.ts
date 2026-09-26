import pg from 'pg';

// Read/write pool (used by import scripts and app data such as inventory/shopping lists).
export const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });

// Read-only pool (used only by execute_read_only_sql so the LLM can never modify data).
export const readOnlyPool = new pg.Pool({
  connectionString: process.env.DATABASE_READONLY_URL,
});
