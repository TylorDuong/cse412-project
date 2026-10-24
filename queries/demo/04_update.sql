-- Phase 2 demo, step 4: UPDATE query (1 pt).
-- Updates the SAME row inserted in 03_insert.sql so the demo is self-contained
-- (does not depend on any particular recipe existing in the imported data).
-- RETURNING shows the new value.

UPDATE recipes
SET energy_kcal_per_serving = 480
WHERE title = 'Vegetable Pasta'
RETURNING id, title, energy_kcal_per_serving;
