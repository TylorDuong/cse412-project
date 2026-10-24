SELECT  id AS ID, 
		is_deleted AS deleted,
		title AS Title, 
		energy_kcal_per_serving AS Calories, 
		protein_g_per_serving AS Protein,
		fat_g_per_serving AS Fat,
		carbs_g_per_serving AS Carbs,
		fiber_g_per_serving AS Fiber,
		sodium_mg_per_serving AS Sodium,
		ner AS "Ingredients (ner)",
		url AS URL
		FROM public.recipes
WHERE	(title ILIKE '%Vegetable Pasta%')
ORDER BY id DESC
LIMIT 200;


