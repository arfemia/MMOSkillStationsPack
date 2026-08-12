# Restore pack content held back from the 0.1.0 (Sawmill-only) release.
#
# Moves files from unreleased/ back into Server/, preserving the mirrored layout.
# Uses `git mv` when the file is tracked so history keeps following it, plain Move-Item otherwise.
#
#   .\unreleased\restore.ps1                    # restore everything
#   .\unreleased\restore.ps1 -WhatIf            # preview only
#   .\unreleased\restore.ps1 -Only Anvil        # restore one group
#
# Groups: Anvil, Cooking, All (default)
#
# Cooking targets the `cookingfire` station, which lives in the RPG Stations jar and is held back
# there too - restore additional-mods/rpg-stations/unreleased/ in the same pass.

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string[]] $Only = @('All')
)

$ErrorActionPreference = 'Stop'
$packRoot = Split-Path -Parent $PSScriptRoot
$held     = Join-Path $packRoot 'unreleased'
$target   = Join-Path $packRoot 'Server'

$bars = @('Adamantite','Cobalt','Copper','Gold','Iron','Mithril','Onyxium','Prisma','Silver','Thorium') |
        ForEach-Object { "Item/Items/Ingredient/MMO_Sharpened_${_}_Bar.json" }

$groups = @{
    Anvil   = @(
        'RpgStations/Stations/Anvil.json',
        'ZiggfreedCommon/RollPools/AnvilWeaponPool.json',
        'Item/Items/RPG_Station_Anvil.json',
        'Item/RootInteractions/RPG_Station_Anvil_Use.json',
        'Item/ResourceTypes/MMO_Sharpened_Bar.json',
        'Emote/MMO_Emote_Hammer.json',
        'MMOSkillTree/CustomSkills/Smithing.json'
    ) + $bars
    Cooking = @(
        'RpgStations/Extensions/CookingProgression.json',
        'MMOSkillTree/CustomSkills/Cooking.json'
    )
}

if ($Only -contains 'All') { $wanted = $groups.Keys } else { $wanted = $Only }

foreach ($name in $wanted) {
    if (-not $groups.ContainsKey($name)) {
        throw "Unknown group '$name'. Valid groups: $($groups.Keys -join ', '), All"
    }
}

$restored = 0
$missing  = 0

foreach ($name in $wanted) {
    foreach ($rel in $groups[$name]) {
        $src = Join-Path $held "Server/$rel"
        $dst = Join-Path $target $rel

        if (-not (Test-Path $src)) {
            Write-Warning "already restored or absent: $rel"
            $missing++
            continue
        }
        if (Test-Path $dst) {
            throw "refusing to overwrite an existing file: $dst"
        }

        if ($PSCmdlet.ShouldProcess($rel, 'restore')) {
            $dstDir = Split-Path -Parent $dst
            if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Force -Path $dstDir | Out-Null }

            $tracked = $false
            try {
                & git -C $packRoot ls-files --error-unmatch -- "unreleased/Server/$rel" *> $null
                if ($LASTEXITCODE -eq 0) { $tracked = $true }
            } catch { $tracked = $false }

            if ($tracked) {
                & git -C $packRoot mv -- "unreleased/Server/$rel" "Server/$rel"
                if ($LASTEXITCODE -ne 0) { throw "git mv failed for $rel" }
            } else {
                Move-Item -LiteralPath $src -Destination $dst
            }
            Write-Host "restored $rel"
            $restored++
        }
    }
}

Write-Host ""
Write-Host "Restored $restored file(s); $missing already absent."
if ($wanted -contains 'Cooking' -and -not $WhatIfPreference) {
    Write-Host "Cooking needs the RPG Stations jar's CookingFire station: run that mod's unreleased\restore.ps1 too." -ForegroundColor Yellow
}
Write-Host "Next: bump manifest.json Version + the RpgStations dependency floor, then .\build.ps1"
