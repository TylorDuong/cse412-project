-- Phase 2 demo, step 3: INSERT query (1 pt).
-- Inserts a demo recipe. RETURNING shows the generated id so the UPDATE/DELETE
-- steps below operate on this exact same row (self-contained, reproducible).

INSERT INTO recipes (
    title, meal_type, ingredients, instructions,
    energy_kcal_per_serving, protein_g_per_serving
) VALUES (
    'Vegetable Pasta',
    'Dinner',
    ARRAY['pasta', 'tomato', 'spinach'],
    'Cook pasta and mix with vegetables.',
    380,
    12
)
RETURNING id, title, meal_type, energy_kcal_per_serving, protein_g_per_serving;
