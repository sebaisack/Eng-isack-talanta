from pathlib import Path
from datetime import datetime

p = Path("results/models.py")
s = p.read_text(encoding="utf-8")

start = s.index("class ResultPromotion(models.Model):")
end = s.index("\n\nclass ResultDetail(models.Model):", start)
block = s[start:end]

block = block.replace(
    "    to_level = models.CharField(max_length=20)```",
    "    to_level = models.CharField(max_length=20)",
    1,
)
block = block.replace(
    "\n```\n",
    "\n",
    1,
)

if "target_competition = models.ForeignKey(" not in block:
    raise SystemExit("ERROR: target_competition haijapatikana; hakuna mabadiliko yaliyohifadhiwa.")

lines = block.splitlines()
for i, line in enumerate(lines):
    if line.startswith("target_competition = models.ForeignKey("):
        lines[i] = "    " + line
        for j in range(i + 1, len(lines)):
            if lines[j].strip() == "":
                continue
            if lines[j].startswith("    ") or lines[j].startswith(")"):
                lines[j] = "    " + lines[j]
            if lines[j].strip() == ")":
                break
        break

block = "\n".join(lines)
block = block.replace("\n    )\n        promoted_by =", "\n    )\n    promoted_by =", 1)

backup = p.with_name(
    p.name + ".backup-fix2-" + datetime.now().strftime("%Y%m%d_%H%M%S")
)
backup.write_bytes(p.read_bytes())
p.write_text(s[:start] + block + s[end:], encoding="utf-8")

print("Backup:", backup)
print("Marekebisho yameandikwa.")
