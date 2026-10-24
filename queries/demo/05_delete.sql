-- Phase 2 demo, step 5: DELETE query (0.5 pt).
-- Removes the demo row inserted/updated above, leaving the database clean.
-- RETURNING shows what was deleted.

DELETE FROM recipes
WHERE title = 'Vegetable Pasta'
RETURNING id, title;
