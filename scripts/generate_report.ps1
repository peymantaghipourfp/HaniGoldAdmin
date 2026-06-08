$reportDir = "reports"
$chartDir = "$reportDir/charts"

New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
New-Item -ItemType Directory -Force -Path $chartDir | Out-Null

Write-Host "📊 Analyzing Git history..."

git log --pretty=format:'%H|%ad|%s' --date=short | Out-File -Encoding utf8 $reportDir\git.log

Write-Host "🧠 Running Flutter analyzer..."

python scripts/analyze_flutter.py

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Analyzer crashed"
    exit 1
}

if (!(Test-Path "reports\metrics.json")) {
    Write-Host "❌ metrics.json not created"
    exit 1
}

Write-Host "📈 Generating charts..."

python scripts/render_charts.py

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Chart generation failed"
    exit 1
}

Write-Host "📄 Building report..."

$md = "$reportDir/report.md"
$html = "$reportDir/report.html"

# pandoc $md -o $reportDir/report.pdf

Write-Host "✅ Done!"