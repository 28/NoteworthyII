if ($args[0]) {
    New-Variable -Name "wow_path" -Value $args[0] -Option Constant -Scope Script
} elseif ($env:WOWIL -and (Test-Path $env:WOWIL)) {
    New-Variable -Name "wow_path" -Value $env:WOWIL -Option Constant -Scope Script
} else {
    Write-Host "WoW installation location must be specified!"
    Exit
}

New-Variable -Name "noteworthy_path" -Value "_retail_\Interface\AddOns\Noteworthy" -Option Constant -Scope Script
New-Variable -Name "install_path" -Value "${wow_path}\${noteworthy_path}\"

Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $install_path
New-Item -ItemType Directory -Path $install_path > $null
New-Item -ItemType Directory -Path "$install_path\lib" > $null
New-Item -ItemType Directory -Path "$install_path\lib\GhostLib" > $null

Copy-Item -Path "..\*" -Include "*.toc", "*.lua", "*.xml" -Destination $install_path -Recurse
Copy-Item -Path "..\lib\*" -Include "*.lua", "*.xml" -Destination "$install_path\lib\" -Recurse
Copy-Item -Path "..\lib\GhostLib\*" -Include "*.lua", "*.xml" -Destination "$install_path\lib\GhostLib\" -Recurse

Write-Host "Successfully installed Noteworthy to '$install_path'."
