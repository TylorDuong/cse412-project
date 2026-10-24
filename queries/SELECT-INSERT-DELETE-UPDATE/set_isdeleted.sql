UPDATE recipes 
SET is_deleted = TRUE 
WHERE 	(title ILIKE 'Steve''s Vegetable Pasta') OR
		(title ILIKE 'Steve''s Vegetable Pasta - UPDATED')
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


