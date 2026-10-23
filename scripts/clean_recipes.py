"""Clean the CulinaAI 1M_Final.csv into a Postgres-ready CSV for COPY into recipes.

Transformations:
  - drop the source string id (recipes.id is SERIAL, generated on insert)
  - ingredients / NER: Python list-literal strings -> Postgres array literals
  - instructions: Python list of steps -> single newline-joined TEXT
  - numeric nutrition columns: non-numeric/empty -> NULL
  - nutrition_confidence: kept as text (high/medium/low)

Usage: python scripts/clean_recipes.py <input_csv> <output_csv> [limit]
Streams row-by-row; does not load the file into memory.
"""
import ast
import csv
import sys

csv.field_size_limit(2**31 - 1)  # instructions fields can be large

# Output columns = recipes table columns minus the SERIAL id, in table order.
OUT_COLS = [
    "title", "url", "meal_type", "primary_classification",
    "secondary_classification", "context_dependent_classification",
    "ingredients", "ner", "instructions",
    "energy_kcal_per_serving", "protein_g_per_serving", "fat_g_per_serving",
    "carbs_g_per_serving", "fiber_g_per_serving", "sodium_mg_per_serving",
    "nutrition_confidence", "image1",
]
NUMERIC = {
    "energy_kcal_per_serving", "protein_g_per_serving", "fat_g_per_serving",
    "carbs_g_per_serving", "fiber_g_per_serving", "sodium_mg_per_serving",
}


def to_pg_array(raw):
    """'[\"a\", \"b\"]'-style Python literal -> Postgres array literal {"a","b"}."""
    raw = (raw or "").strip()
    if not raw:
        return "{}"
    try:
        items = ast.literal_eval(raw)
        if not isinstance(items, (list, tuple)):
            items = [str(items)]
    except (ValueError, SyntaxError):
        return "{}"
    parts = []
    for it in items:
        s = str(it).replace("\\", "\\\\").replace('"', '\\"')
        parts.append('"' + s + '"')
    return "{" + ",".join(parts) + "}"


def join_steps(raw):
    raw = (raw or "").strip()
    if not raw:
        return ""
    try:
        steps = ast.literal_eval(raw)
        if isinstance(steps, (list, tuple)):
            return "\n".join(str(s) for s in steps)
    except (ValueError, SyntaxError):
        pass
    return raw


def num(raw):
    raw = (raw or "").strip()
    if not raw:
        return ""
    try:
        float(raw)
        return raw
    except ValueError:
        return ""


def main():
    inp, outp = sys.argv[1], sys.argv[2]
    limit = int(sys.argv[3]) if len(sys.argv) > 3 else None
    written = skipped = 0
    with open(inp, encoding="utf-8", newline="") as fin, \
         open(outp, "w", encoding="utf-8", newline="") as fout:
        reader = csv.DictReader(fin)
        writer = csv.writer(fout)
        writer.writerow(OUT_COLS)
        for row in reader:
            if not (row.get("title") or "").strip():
                skipped += 1
                continue
            out = []
            for col in OUT_COLS:
                if col == "ner":
                    out.append(to_pg_array(row.get("NER")))
                elif col in ("ingredients",):
                    out.append(to_pg_array(row.get(col)))
                elif col == "instructions":
                    out.append(join_steps(row.get(col)))
                elif col in NUMERIC:
                    out.append(num(row.get(col)))
                else:
                    out.append((row.get(col) or "").strip())
            writer.writerow(out)
            written += 1
            if written % 100000 == 0:
                print(f"  ...{written} rows", flush=True)
            if limit and written >= limit:
                break
    print(f"done: wrote {written} rows, skipped {skipped} (no title)")


if __name__ == "__main__":
    main()
