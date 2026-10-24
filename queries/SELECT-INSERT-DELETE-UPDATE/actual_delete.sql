DELETE FROM public.recipes
WHERE is_deleted = TRUE
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
