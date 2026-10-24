SELECT
    id,
    TRIM(BOTH '-' FROM TRIM(title)) AS title,
    meal_type,
    ner
FROM public.recipes
WHERE title ILIKE '%chicken%'
LIMIT 10;
