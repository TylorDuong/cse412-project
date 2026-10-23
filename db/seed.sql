-- Seed / demo data for the Culinary Assistant.
-- Small, hand-written rows used for development and the demo. Bulk recipe data
-- is loaded separately via COPY from the Kaggle CSV (see README setup).
-- Safe to re-run: existing rows are left untouched.

INSERT INTO users (first_name, last_name) VALUES
  ('Demo', 'User')
ON CONFLICT DO NOTHING;

INSERT INTO basket_products (brand, name, quantity, search_term) VALUES
  ('Generic', 'Chicken Breast', '1 lb',  'chicken'),
  ('Generic', 'Olive Oil',      '500 ml','oil'),
  ('Generic', 'White Rice',     '2 lb',  'rice')
ON CONFLICT (brand, name) DO NOTHING;

INSERT INTO user_inventory (user_id, ingredients) VALUES
  (1, ARRAY['chicken','rice','olive oil'])
ON CONFLICT (user_id) DO NOTHING;
