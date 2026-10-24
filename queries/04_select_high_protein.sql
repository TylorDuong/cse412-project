
-- SELECT Query 1: High protein and low calorie recipes

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