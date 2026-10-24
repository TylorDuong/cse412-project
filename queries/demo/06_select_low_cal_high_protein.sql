-- Phase 2 demo, step 6: SELECT query 1 of 2 (part of 1.5 pt).
-- Application feature: "low-calorie, high-protein" recipe search.

SELECT
    id,
    title,
    meal_type,
    energy_kcal_per_serving,
    protein_g_per_serving
FROM recipes
WHERE energy_kcal_per_serving < 500
  AND protein_g_per_serving >= 30
ORDER BY
    protein_g_per_serving DESC,
    energy_kcal_per_serving ASC
LIMIT 10;
