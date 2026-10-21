-- Schema derived from the Phase 1 ER diagram. Draft: adjust once the dataset is inspected.

CREATE TABLE IF NOT EXISTS users (
  id          SERIAL PRIMARY KEY,
  first_name  TEXT NOT NULL,
  last_name   TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS recipes (
  id                            SERIAL PRIMARY KEY,
  source_id                     TEXT UNIQUE,  --maybe keep the source id from csv, can have duplicate import ? not sure if needed.
  title                         TEXT NOT NULL,
  url                           TEXT,
  meal_type                     TEXT,
  primary_classification        TEXT,
  secondary_classification      TEXT,
  context_dependent_classification TEXT,
  ingredients                   TEXT[],
  ner                           TEXT[],
  instructions                  TEXT,
  energy_kcal_per_serving       NUMERIC,
  protein_g_per_serving         NUMERIC,
  fat_g_per_serving             NUMERIC,
  carbs_g_per_serving           NUMERIC,
  fiber_g_per_serving           NUMERIC,
  sodium_mg_per_serving         NUMERIC,
  nutrition_confidence          TEXT,
  image1                        TEXT
);

CREATE TABLE IF NOT EXISTS ratings (
  rating_id  SERIAL PRIMARY KEY,
  user_id    INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  recipe_id  INT NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  star_count SMALLINT CHECK (star_count BETWEEN 1 AND 5),
  rating_comment TEXT
);

CREATE TABLE IF NOT EXISTS basket_products (
  brand       TEXT NOT NULL,
  name        TEXT NOT NULL,
  quantity    TEXT,
  search_term TEXT,
  raw_name    TEXT,
  image       TEXT,
  PRIMARY KEY (brand, name)
);

CREATE TABLE IF NOT EXISTS user_inventory (
  user_id     INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  ingredients TEXT[] NOT NULL DEFAULT '{}',
  PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS shopping_lists (
  id          SERIAL PRIMARY KEY,
  user_id     INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  date        DATE NOT NULL,
  ingredients TEXT[] NOT NULL DEFAULT '{}'
);

-- "contains": shopping list <-> basket products <-> recipes
CREATE TABLE IF NOT EXISTS shopping_list_products (
  shopping_list_id INT NOT NULL REFERENCES shopping_lists(id) ON DELETE CASCADE,
  brand            TEXT NOT NULL,
  name             TEXT NOT NULL,
  FOREIGN KEY (brand, name) REFERENCES basket_products(brand, name),
  PRIMARY KEY (shopping_list_id, brand, name)
);

-- Read-only role for execute_read_only_sql(). Set the password before running in a real environment.
-- DO $$ BEGIN
--   CREATE ROLE culinary_ro LOGIN PASSWORD 'culinary_ro';
-- EXCEPTION WHEN duplicate_object THEN NULL; END $$;
-- GRANT CONNECT ON DATABASE culinary TO culinary_ro;
-- GRANT USAGE ON SCHEMA public TO culinary_ro;
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO culinary_ro;
