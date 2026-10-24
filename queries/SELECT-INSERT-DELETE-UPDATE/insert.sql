INSERT INTO recipes (
    title,
	is_deleted,
    meal_type,
    ingredients,
    instructions,
    energy_kcal_per_serving,
    protein_g_per_serving,
	fat_g_per_serving,
	carbs_g_per_serving,
	fiber_g_per_serving,
	sodium_mg_per_serving
)
VALUES (
    'Steve''s Vegetable Pasta',
	FALSE,
    'Dinner',
    ARRAY['pasta', 'tomato', 'spinach'],
    'Cook pasta and mix with vegetables.',
    380,
    12, 
	65,
	85, 
	630,
	1220
)
RETURNING 	id, 
			is_deleted, 
			title, 
			meal_type, 
			ingredients, 
			instructions, 
			energy_kcal_per_serving,
		    protein_g_per_serving,
			fat_g_per_serving,
			carbs_g_per_serving,
			fiber_g_per_serving,
			sodium_mg_per_serving;


