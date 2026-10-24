-- Phase 2 demo, step 7: SELECT query 2 of 2 (part of 1.5 pt).
-- Application feature: ingredient-based search over the array column.
-- Searches the NER ingredient list for anything containing 'chicken'.

SELECT
    id,
    title,
    meal_type,
    ner
FROM recipes
WHERE EXISTS (
    SELECT 1
    FROM unnest(COALESCE(ner, ARRAY[]::TEXT[])) AS ingredient
    WHERE ingredient ILIKE '%chicken%'
)
ORDER BY title
LIMIT 10;
