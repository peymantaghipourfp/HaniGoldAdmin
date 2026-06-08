import json
import os
import matplotlib.pyplot as plt

BASE = "reports"
metrics_path = os.path.join(BASE, "metrics.json")

if not os.path.exists(metrics_path):
    print("❌ metrics.json NOT FOUND → run analyzer first")
    exit(1)

with open(metrics_path, "r", encoding="utf-8") as f:
    data = json.load(f)

charts_dir = os.path.join(BASE, "charts")
os.makedirs(charts_dir, exist_ok=True)

# Feature chart
plt.figure()
plt.bar(data["features"].keys(), data["features"].values())
plt.title("Feature Distribution")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig(os.path.join(charts_dir, "features.png"))

# Architecture chart
plt.figure()

layers = ["controllers","models","views","widgets","repositories","services"]
values = [data.get(l, 0) for l in layers]

plt.bar(layers, values)
plt.title("Architecture Breakdown")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig(os.path.join(charts_dir, "layers.png"))

print("✅ charts generated")