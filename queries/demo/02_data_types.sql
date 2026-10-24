-- Phase 2 demo, step 2: Information Representation / data-type check.
-- Proves numeric fields (price-like: calories, protein, etc.) are NUMERIC, not INTEGER.
--
-- In the psql console the quickest version is the meta-command:
--     \d recipes
--
-- The portable, -f-friendly equivalent below works anywhere and prints the
-- same information (column name + declared data type):

SELECT column_name, data_type, numeric_precision, numeric_scale
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'recipes'
ORDER BY ordinal_position;
