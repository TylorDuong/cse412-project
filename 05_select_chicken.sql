
-- SELECT Query 2:chicken recipes  

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
