$files = @(
  'lib\presentation\pages\dashboard_page.dart',
  'lib\presentation\pages\pricing_page.dart',
  'lib\presentation\pages\settings_page.dart',
  'lib\presentation\pages\logs_page.dart',
  'lib\presentation\pages\charts_page.dart',
  'lib\presentation\pages\accounts_page.dart'
)

foreach ($file in $files) {
  $content = Get-Content $file -Raw
  $newContent = $content -replace 'l10n\.(\w+)\(\)', 'l10n.$1'
  Set-Content $file -Value $newContent -NoNewline
  Write-Host "Fixed: $file"
}

Write-Host "Done!"
