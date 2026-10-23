-- Bulk data import for the Culinary Assistant.
-- Expects two files in data/ (git-ignored), produced from the Kaggle dataset:
--   data/recipes_clean.csv   -- from: python scripts/clean_recipes.py <path>/1M_Final.csv data/recipes_clean.csv
--   data/basket_products.csv -- copy of the dataset's Basket_Products.csv
-- Run with: npm run db:import   (or: psql -d culinary -f db/import.sql)
-- Re-runnable: recipes are reloaded fresh; basket rows upsert by (brand,name).

\echo Importing recipes (this takes a few minutes for ~1M rows)...
TRUNCATE recipes RESTART IDENTITY CASCADE;
\copy recipes(title,url,meal_type,primary_classification,secondary_classification,context_dependent_classification,ingredients,ner,instructions,energy_kcal_per_serving,protein_g_per_serving,fat_g_per_serving,carbs_g_per_serving,fiber_g_per_serving,sodium_mg_per_serving,nutrition_confidence,image1) FROM 'data/recipes_clean.csv' WITH (FORMAT csv, HEADER true);

\echo Importing basket products...
DROP TABLE IF EXISTS basket_staging;
CREATE TABLE basket_staging (brand text, name text, quantity text, raw_name text, image text, search_term text);
\copy basket_staging(brand,name,quantity,raw_name,image,search_term) FROM 'data/basket_products.csv' WITH (FORMAT csv, HEADER true);
INSERT INTO basket_products(brand,name,quantity,search_term,raw_name,image)
  SELECT DISTINCT ON (brand,name)
    brand, name, NULLIF(quantity,''), NULLIF(search_term,''), NULLIF(raw_name,''), NULLIF(image,'')
  FROM basket_staging
  WHERE COALESCE(brand,'') <> '' AND COALESCE(name,'') <> ''
  ON CONFLICT (brand,name) DO NOTHING;
DROP TABLE basket_staging;

\echo Done. Row counts:
SELECT 'recipes' AS table, count(*) AS rows FROM recipes
UNION ALL SELECT 'basket_products', count(*) FROM basket_products;
