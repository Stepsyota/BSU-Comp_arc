import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import find_peaks

# === ПАРАМЕТРЫ ===
CSV_PATH = "cache_table.csv"  # путь к твоему CSV
CACHE_LEVELS = {
    "L1 Cache (32 KB)": 32 * 1024,
    "L2 Cache (256 KB)": 256 * 1024,
    "L3 Cache (8 MB)": 8 * 1024 * 1024
}

# === ЗАГРУЗКА И ОЧИСТКА ===
df = pd.read_csv(CSV_PATH)
expected_cols = {"Byte_size", "Stride", "Time", "Chain_type"}
if not expected_cols.issubset(df.columns):
    raise ValueError(f"CSV должен содержать колонки: {expected_cols}")
print(df.head(30))
df["Byte_size"] = df["Byte_size"].astype(float)

# Округляем к ближайшей степени двойки — если измерения не идеально кратны
df["Byte_size"] = 2 ** np.round(np.log2(df["Byte_size"]))

# === ГРУППИРОВКА ===
grouped = (
    df.groupby(["Byte_size", "Chain_type"], as_index=False)
    .agg(mean_time=("Time", "mean"),
         min_time=("Time", "min"),
         max_time=("Time", "max"))
    .sort_values("Byte_size")
)

# === ФОРМАТИРОВАНИЕ ВЫВОДА ===
def format_bytes(x):
    if x >= 1024**2:
        return f"{int(x / 1024**2)} MB"
    elif x >= 1024:
        return f"{int(x / 1024)} KB"
    return f"{int(x)} B"


# === ВИЗУАЛИЗАЦИЯ ===
plt.figure(figsize=(11, 6))
ax = plt.gca()

for chain_type, sub in grouped.groupby("Chain_type"):
    sub = sub.sort_values("Byte_size")

    # Ступенчатая линия
    plt.step(
        sub["Byte_size"], sub["mean_time"],
        where='post', label=f"{chain_type} (mean)", linewidth=2
    )

    # Диапазон min-max
    plt.fill_between(
        sub["Byte_size"], sub["min_time"], sub["max_time"],
        step='post', alpha=0.25
    )

# === АНАЛИЗ СКАЧКОВ ===
avg_curve = (
    df.groupby("Byte_size")["Time"]
    .mean()
    .reset_index()
    .sort_values("Byte_size")
)

diff = np.gradient(avg_curve["Time"].values)
peaks, _ = find_peaks(diff, prominence=np.std(diff) * 0.6)

print("=== Обнаруженные скачки (возможные границы кэшей) ===")
for p in peaks:
    size = avg_curve["Byte_size"].iloc[p]
    label = format_bytes(size)
    print(f"→ {label} (≈ {size:.0f} байт)")

    # Добавляем отметку на график
    plt.scatter(size, avg_curve["Time"].iloc[p],
                color='red', s=50, zorder=5, label=None)
    plt.text(size, avg_curve["Time"].iloc[p] * 1.03, label,
             rotation=45, fontsize=8, color='red',
             ha='left', va='bottom')

# === ЛИНИИ УРОВНЕЙ КЭША ===
for name, size in CACHE_LEVELS.items():
    plt.axvline(x=size, color='gray', linestyle='--', alpha=0.6)
    plt.text(size, plt.ylim()[1] * 0.97, name, rotation=90,
             verticalalignment='top', horizontalalignment='right',
             fontsize=8, color='gray')

# === ОФОРМЛЕНИЕ ===
plt.xscale('log', base=2)
plt.yscale('log', base=2)
ax.xaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: format_bytes(x)))
plt.xlabel("Размер данных", fontsize=12)
plt.ylabel("Время доступа (нс)", fontsize=12)
plt.title("Время доступа к кэш-памяти CPU", fontsize=14, fontweight='bold')

plt.grid(True, which="both", linestyle="--", alpha=0.5)
plt.legend()
plt.tight_layout()
plt.show()