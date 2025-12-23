import json
import argparse
from pathlib import Path
from datetime import datetime

parser = argparse.ArgumentParser(description="Generate HTML report from JSON complexity file")
parser.add_argument("--input", "-i", required=True, help="Path to input JSON file")
parser.add_argument("--output", "-o", required=True, help="Path to output HTML file")
args = parser.parse_args()

input_path = Path(args.input)
output_path = Path(args.output)

with open(input_path, "r", encoding="utf-8") as f:
    data = json.load(f)

# Вычисляем общие характеристики по всем файлам
total_functions = 0
total_cyclomatic = 0
total_cognitive = 0
max_cyclomatic = 0
max_cognitive = 0

for file in data.get("files", []):
    summary = file.get("summary", {})
    total_functions += summary.get("totalFunctions", 0)
    total_cyclomatic += summary.get("totalCyclomaticComplexity", 0)
    total_cognitive += summary.get("totalCognitiveComplexity", 0)
    max_cyclomatic = max(max_cyclomatic, summary.get("maxCyclomaticComplexity", 0))
    max_cognitive = max(max_cognitive, summary.get("maxCognitiveComplexity", 0))

average_cyclomatic = total_cyclomatic / total_functions if total_functions else 0
average_cognitive = total_cognitive / total_functions if total_functions else 0

html = f"""
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Complexity Report</title>
<style>
body {{ font-family: Arial, sans-serif; margin: 20px; font-size: 14px; }}
h1 {{ color: #333; font-size: 24px; }}
h2 {{ color: #555; font-size: 20px; margin-top: 30px; }}
table {{ border-collapse: collapse; width: 100%; margin-top: 10px; }}
th, td {{ border: 1px solid #ccc; padding: 6px 8px; text-align: left; font-size: 13px; }}
th {{ background-color: #f2f2f2; }}
tr:nth-child(even) {{ background-color: #fafafa; }}
.code {{ font-family: monospace; white-space: pre-wrap; background-color: #f8f8f8; padding: 4px; }}
.summary-card {{ display: inline-block; background: #f5f5f5; padding: 8px 12px; margin: 4px; border-radius: 5px; font-size: 13px; }}
.summary-title {{ font-weight: bold; margin-bottom: 4px; }}
.high-cyclomatic {{ background-color: #ffcccc; }}
.high-cognitive {{ background-color: #ffe0b3; }}
</style>
</head>
<body>
<h1>Complexity Report</h1>
<p>Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>

<h2>Overall Summary</h2>
<div style='margin-bottom:20px;'>
<div class='summary-card'><div class='summary-title'>Total Files</div>{len(data.get("files", []))}</div>
<div class='summary-card'><div class='summary-title'>Total Functions</div>{total_functions}</div>
<div class='summary-card'><div class='summary-title'>Total Cyclomatic Complexity</div>{total_cyclomatic}</div>
<div class='summary-card'><div class='summary-title'>Total Cognitive Complexity</div>{total_cognitive}</div>
<div class='summary-card'><div class='summary-title'>Max Cyclomatic Complexity</div>{max_cyclomatic}</div>
<div class='summary-card'><div class='summary-title'>Max Cognitive Complexity</div>{max_cognitive}</div>
<div class='summary-card'><div class='summary-title'>Average Cyclomatic Complexity</div>{average_cyclomatic:.2f}</div>
<div class='summary-card'><div class='summary-title'>Average Cognitive Complexity</div>{average_cognitive:.2f}</div>
</div>
"""

# Детальный отчет по каждому файлу
for file in data.get("files", []):
    functions = file.get("functions", [])
    if not functions:
        continue

    file_path = file["filePath"]
    summary = file["summary"]
    
    html += f"<h2>File: {file_path}</h2>\n"
    html += "<div style='margin-bottom:10px;'>\n"
    html += f"<div class='summary-card'><div class='summary-title'>Total Functions</div>{summary['totalFunctions']}</div>"
    html += f"<div class='summary-card'><div class='summary-title'>Total Cyclomatic Complexity</div>{summary['totalCyclomaticComplexity']}</div>"
    html += f"<div class='summary-card'><div class='summary-title'>Total Cognitive Complexity</div>{summary['totalCognitiveComplexity']}</div>"
    html += f"<div class='summary-card'><div class='summary-title'>Max Cyclomatic Complexity</div>{summary['maxCyclomaticComplexity']}</div>"
    html += f"<div class='summary-card'><div class='summary-title'>Max Cognitive Complexity</div>{summary['maxCognitiveComplexity']}</div>"
    html += f"<div class='summary-card'><div class='summary-title'>Average Cyclomatic Complexity</div>{summary['averageCyclomaticComplexity']:.2f}</div>"
    html += f"<div class='summary-card'><div class='summary-title'>Average Cognitive Complexity</div>{summary['averageCognitiveComplexity']:.2f}</div>"
    html += "</div>\n"
    
    html += "<table>\n<tr><th>#</th><th>Name</th><th>Signature</th><th>Line</th><th>Cyclomatic</th><th>Cognitive</th></tr>\n"
    
    for i, func in enumerate(functions, 1):
        line = func["location"]["line"]
        name = func.get("name", "")
        signature = func.get("signature", "")
        cyclomatic = func.get("cyclomaticComplexity", 0)
        cognitive = func.get("cognitiveComplexity", 0)
        
        cyclomatic_class = "high-cyclomatic" if cyclomatic > 5 else ""
        cognitive_class = "high-cognitive" if cognitive > 3 else ""
        
        html += f"<tr><td>{i}</td><td>{name}</td><td class='code'>{signature}</td><td>{line}</td>"
        html += f"<td class='{cyclomatic_class}'>{cyclomatic}</td><td class='{cognitive_class}'>{cognitive}</td></tr>\n"
    
    html += "</table>\n"

html += """
</body>
</html>
"""

output_path.write_text(html, encoding="utf-8")
print(f"Report generated: {output_path}")
