-- Phase 2 demo, step 1: show the tables created by db/schema.sql.
-- Satisfies "import data and SELECT * FROM tables" (show what was created).
-- Run after: npm run db:setup && npm run db:import

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Then prove each table has rows (swap in any table name):
SELECT 'recipes'         AS table, count(*) AS rows FROM recipes
UNION ALL SELECT 'users',                  count(*) FROM users
UNION ALL SELECT 'ratings',                count(*) FROM ratings
UNION ALL SELECT 'basket_products',        count(*) FROM basket_products
UNION ALL SELECT 'user_inventory',         count(*) FROM user_inventory
UNION ALL SELECT 'shopping_lists',         count(*) FROM shopping_lists
UNION ALL SELECT 'shopping_list_products', count(*) FROM shopping_list_products;

-- Show a few actual rows:
SELECT id, title, meal_type, energy_kcal_per_serving, protein_g_per_serving
FROM recipes
LIMIT 10;
