SELECT  id AS ID, 
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
WHERE	(title ILIKE 'z%') AND
		(array_to_string(ner, ' ') NOT ILIKE '%zucchini%') AND
		(array_to_string(ner, ' ') ILIKE '%%') AND
	  	energy_kcal_per_serving BETWEEN 0 AND 8000
ORDER BY energy_kcal_per_serving ASC
LIMIT 10;