# Phase 2 Demo — run order

Run these in the PostgreSQL console in order. Covers every DEMO sub-rubric.

Prereq (one time): the two git-ignored CSVs must be in `data/`
(`recipes_clean.csv`, `basket_products.csv`), then:

```
npm run db:setup     # createdb + schema + seed
npm run db:import     # COPY the bulk data (takes a few minutes)
```

| File | Rubric item | Points |
|------|-------------|--------|
| `01_show_tables.sql` | Import data + `SELECT * FROM` tables | 3 |
| `02_data_types.sql`  | Information representation / data-type check (also `\d recipes`) | 1 |
| `03_insert.sql`      | DEMO: INSERT query | 1 |
| `04_update.sql`      | DEMO: UPDATE query | 1 |
| `05_delete.sql`      | DEMO: DELETE query | 0.5 |
| `06_select_low_cal_high_protein.sql` | DEMO: selection query 1 | 0.75 |
| `07_select_ingredient_search.sql`    | DEMO: selection query 2 | 0.75 |

Steps 03→04→05 operate on the same demo row (`'Vegetable Pasta'`), so the
sequence is self-contained and leaves the database unchanged afterward.

To run a single file from the shell:
```
psql -d culinary -f queries/demo/03_insert.sql
```
