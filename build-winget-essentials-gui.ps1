<#
.SYNOPSIS
Compile un script PowerShell en executable.

.DESCRIPTION
Ce script utilise le module `ps2exe` pour convertir le script `winget-essentials-gui.ps1` en une application Windows autonome (.exe). 

.NOTES
Auteur     : Kevin Gaonach  
Site Web   : https://github.com/kevin-gaonach/winget-essentials-gui  
Version    : 1.0.0.0 
Date       : 2025-07-25

.EXAMPLE
.\Build-WingetGui.ps1
Compile le script `winget-essentials-gui.ps1` en executable avec icône et elevation.
#>


# Verifier si le module ps2exe est installe
if (-not (Get-Module -ListAvailable -Name ps2exe)) {
    Install-Module -Name ps2exe -Scope CurrentUser -Force
}

# Importer le module
Import-Module ps2exe -Force

# Compiler le script PowerShell en executable avec icône et elevation
Invoke-ps2exe -inputFile .\winget-essentials-gui.ps1 `
              -iconFile .\winget-essentials-gui.ico `
			  -version "1.0.0.0" `
			  -product "winget-essentials-gui" `
			  -copyright "Kevin Gaonach" `
              -requireAdmin `
              -outputFile .\winget-essentials-gui.exe
