Write-Host "=== Black Ops 3 Workshop Language Adder===" -ForegroundColor Cyan
Write-Host "=== Made by randagioblu ===" -ForegroundColor Blue

$expectedSubPath = "steamapps\workshop\content\311210"

do {
    $root = Read-Host "Paste the directory of Black Ops 3 workshop folder (example: E:\SteamLibrary\steamapps\workshop\content\311210)"

    if (!(Test-Path $root)) {
        Write-Host "Directory does not exist." -ForegroundColor Red
        continue
    }

    if ($root.ToLower() -notlike "*$($expectedSubPath.ToLower())*") {
        Write-Host "This is not the Black Ops 3 workshop folder (311210)." -ForegroundColor Red
        continue
    }

    break

} while ($true)


Write-Host ""
Write-Host "Select the language to generate:" -ForegroundColor Yellow
Write-Host "it = Italian"
Write-Host "bp = Brazilian Portuguese"
Write-Host "ea = Latin American Spanish"
Write-Host "es = Spanish"
Write-Host "fr = French"
Write-Host "ge = German"
Write-Host "ru = Russian"
Write-Host ""

$lang = Read-Host "Type language code (it, bp, ea, es, fr, ge, ru)"

$validLanguages = @("it","bp","ea","es","fr","ge","ru")

if ($validLanguages -notcontains $lang) {
    Write-Host "Invalid language selected." -ForegroundColor Red
    Read-Host "Press ENTER to exit"
    exit
}

$languageNames = @{
    "it" = "Italian"
    "bp" = "Brazilian Portuguese"
    "ea" = "Latin American Spanish"
    "es" = "Spanish"
    "fr" = "French"
    "ge" = "German"
    "ru" = "Russian"
}

Get-ChildItem -Path $root -Directory | ForEach-Object {

    $modDir = $_.FullName

 
    # FF/XPAK FILE
	
    $enFF   = Get-ChildItem $modDir -Filter "en_zm_*.ff"   -ErrorAction SilentlyContinue
    $enXPAK = Get-ChildItem $modDir -Filter "en_zm_*.xpak" -ErrorAction SilentlyContinue

    foreach ($file in $enFF) {
        $targetName = $file.Name -replace "^en_", "$lang`_"
        $targetPath = Join-Path $modDir $targetName

        if (!(Test-Path $targetPath)) {
            Copy-Item $file.FullName $targetPath
        }
    }

    foreach ($file in $enXPAK) {
        $targetName = $file.Name -replace "^en_", "$lang`_"
        $targetPath = Join-Path $modDir $targetName

        if (!(Test-Path $targetPath)) {
            Copy-Item $file.FullName $targetPath
        }
    }

    
    # SND FOLDER
    
    $sndDir = Join-Path $modDir "snd"
    $enSnd  = Join-Path $sndDir "en"
    $langSnd = Join-Path $sndDir $lang

    if ((Test-Path $enSnd) -and !(Test-Path $langSnd)) {

        New-Item -ItemType Directory -Path $langSnd | Out-Null

        Get-ChildItem $enSnd -Filter "*.en.sab*" | ForEach-Object {
            $newName = $_.Name -replace "\.en\.", ".$lang."
            Copy-Item $_.FullName (Join-Path $langSnd $newName)
        }
    }
}

Write-Host ""
Write-Host "Operation completed for language: $($languageNames[$lang])" -ForegroundColor Green
Read-Host "Press ENTER to exit"
