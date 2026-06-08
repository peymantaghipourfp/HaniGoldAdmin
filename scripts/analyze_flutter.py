import os
import json
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BASE_DIR = os.path.join(ROOT, "lib", "src")

REPORT_DIR = os.path.join(ROOT, "reports")
os.makedirs(REPORT_DIR, exist_ok=True)

stats = {
    "controllers": 0,
    "models": 0,
    "views": 0,
    "widgets": 0,
    "repositories": 0,
    "services": 0,
    "features": defaultdict(int)
}

def classify(path):
    if "controller" in path:
        return "controllers"
    if "model" in path:
        return "models"
    if "view" in path:
        return "views"
    if "widget" in path:
        return "widgets"
    if "repository" in path:
        return "repositories"
    if "service" in path:
        return "services"
    return None

found_any = False

for root, _, files in os.walk(BASE_DIR):
    for f in files:
        if f.endswith(".dart"):
            found_any = True
            full = os.path.join(root, f)
            rel = full.replace("\\", "/")

            kind = classify(rel)
            if kind:
                stats[kind] += 1

            for p in rel.split("/"):
                if p in ["chat","order","users","inventory","deposit","withdraw","product"]:
                    stats["features"][p] += 1

if not found_any:
    print("❌ NO DART FILES FOUND - check BASE_DIR:", BASE_DIR)
    exit(1)

output_file = os.path.join(REPORT_DIR, "metrics.json")

with open(output_file, "w", encoding="utf-8") as f:
    json.dump(stats, f, indent=2)

print("✅ metrics.json created:", output_file)
