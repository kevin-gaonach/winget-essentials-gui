<#
.SYNOPSIS
Interface graphique PowerShell pour l'installation et la mise a jour d'applications via WinGet.

.DESCRIPTION
Ce script installe le module WinGet si necessaire,
et affiche une interface graphique (GUI) permettant de selectionner et d’installer des applications courantes 
par categories (Developpement, Bureautique, Admins, Gaming, etc.) en utilisant WinGet. 

Trois boutons permettent :
- tout cocher / tout decocher
- installer les applications selectionnees
- mettre a jour toutes les applications WinGet installees

.NOTES
Auteur     : Kevin Gaonach  
Site Web   : https://github.com/kevin-gaonach/winget-essentials-gui  
Version    : 1.0.0.0 
Date       : 2025-07-29

.EXAMPLE
.\winget-essentials-gui.ps1
Lance le script et affiche une selection d'application a installer avec WinGet.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$progressPreference = 'silentlyContinue'

function Show-AppInstallerGUI {

    $currentY = 5

    $form = New-Object Windows.Forms.Form
    $form.Text = "Winget Essentials GUI"
    $form.AutoSize = $true
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.StartPosition = "CenterScreen"
    $form.Width = 750


	$titleLabel = New-Object Windows.Forms.Label
	$titleLabel.Text = "Selecteur d'application"
	$titleLabel.Font = New-Object Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
	$titleLabel.AutoSize = $true
	$titleLabel.Location = New-Object Drawing.Point(0, $currentY)
	$form.Controls.Add($titleLabel)

    $currentY += 25

	$subtitleLabel = New-Object Windows.Forms.Label
	$subtitleLabel.Text = "Par Kevin GAONACH"
	$subtitleLabel.Font = New-Object Drawing.Font("Segoe UI", 8)
	$subtitleLabel.AutoSize = $true
	$subtitleLabel.Location = New-Object Drawing.Point(0, $currentY)
	$form.Controls.Add($subtitleLabel)

	$form.Add_Shown({
		$titleLabel.Left = ($form.ClientSize.Width - $titleLabel.Width) / 2
		$subtitleLabel.Left = ($form.ClientSize.Width - $subtitleLabel.Width) / 2
	})

    # Recupere la liste des apps deja installees
    $installedWingetIds = (Get-WinGetPackage).id

    $categories = [ordered]@{
        "Bureautique" = [ordered]@{
			"Adobe Reader" = "Adobe.Acrobat.Reader.64-bit"
            "PDFsam" = "PDFsam.PDFsam"
            "7-Zip" = "7zip.7zip"
            "Ant Renamer" = "AntSoftware.AntRenamer"
            "Greenshot" = "Greenshot.Greenshot"
            "Chrome" = "Google.Chrome"
            "Firefox" = "Mozilla.Firefox.fr"
			"Brave" = "Brave.Brave"
        }
        "Multimedia" = [ordered]@{
			"VLC" = "VideoLAN.VLC"
			"Amazon Music" = "9NMS233VM4Z9"
            "Deezer" = "9NBLGGH6J7VV"
            "Spotify" = "9NCBCSZSJRSB"
            "Disney+" = "9NXQXXLFST89"
			"Amazon Video" = "9P6RC76MSMMJ"
			"Netflix" = "9WZDNCRFJ3TJ"
			"Plex" = "XP9CDQW6ML4NQN"
        }
		"Securite" = [ordered]@{
            "VPN TunnelBear" = "TunnelBear.TunnelBear"
			"VPN Proton" = "Proton.ProtonVPN"
			"VPN WireGuard" = "WireGuard.WireGuard"
			"TeamViewer" = "TeamViewer.TeamViewer"
		    "Veeam Agent" = "Veeam.VeeamAgent"
			"Malwarebytes" = "Malwarebytes.Malwarebytes"
            "KeePassXC" = "KeePassXCTeam.KeePassXC"
            "Bitwarden" = "Bitwarden.Bitwarden"
		}
		"Hardware" = [ordered]@{
			"Logitech G HUB" = "Logitech.GHUB"
			"Corsair iCUE 5" = "Corsair.iCUE.5"
			"MSI Center" = "9NVMNJCR03XV"
			"StreamDeck" = "Elgato.StreamDeck"
		}
		"Gaming" = [ordered]@{
            "Playnite" = "Playnite.Playnite"
            "OBS Studio" = "OBSProject.OBSStudio"
            "Amazon Games" = "Amazon.Games"
            "EA Desktop" = "ElectronicArts.EADesktop"
            "Epic Games" = "EpicGames.EpicGamesLauncher"
            "Steam" = "Valve.Steam"
            "Ubisoft Connect" = "Ubisoft.Connect"
            "GOG Galaxy" = "GOG.Galaxy"
        }
		"Monitoring" = [ordered]@{
            "Rivatuner Statistics Server" = "Guru3D.RTSS"
            "Afterburner" = "Guru3D.Afterburner"
			"HWMonitor" = "CPUID.HWMonitor"
			"Crystal Disk Info" = "CrystalDewWorld.CrystalDiskInfo"
        }
		"Benchmark" = [ordered]@{
			"OCCT" = "OCBase.OCCT.Personal"
			"Crystal Disk Mark" = "CrystalDewWorld.CrystalDiskMark"
			"Cinebench R23" = "Maxon.CinebenchR23"
            "Geekbench" = "PrimateLabs.Geekbench.6"
		}
        "Communication" = [ordered]@{
            "Discord" = "Discord.Discord"
            "Teams" = "Microsoft.Teams.Free"
            "Facebook Messenger" = "9WZDNCRF0083"
            "WhatsAPP" = "9NKSQGP7F2NH"
        }
        "Systeme et Reseau" = [ordered]@{
            "mRemoteNG" = "mRemoteNG.mRemoteNG"
            "PuTTY" = "PuTTY.PuTTY"
            "WinSCP" = "WinSCP.WinSCP"
            "WingetUI" = "MartiCliment.UniGetUI"
            "Advanced IP Scanner" = "Famatech.AdvancedIPScanner"
            "WireShark" = "WiresharkFoundation.Wireshark"
            "WinDirStat" = "WinDirStat.WinDirStat"
            "System Informer" = "WinsiderSS.SystemInformer"
        }
        "Developpement" = [ordered]@{
			"GitHub Desktop" = "GitHub.GitHubDesktop"
            "Notepad++" = "Notepad++.Notepad++"
            "Visual Studio Code" = "Microsoft.VisualStudioCode"
            "Powershell 7" = "Microsoft.PowerShell"
        }
    }

    $checkboxes = @{}
    $currentY += 0
    $padding = 10
    $checkboxWidth = 180
    $checkboxHeight = 22
    $formWidth = $form.ClientSize.Width

    foreach ($category in $categories.Keys) {
        $label = New-Object Windows.Forms.Label
        $label.Text = "$category"
        $label.Font = New-Object Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $label.Location = New-Object Drawing.Point($padding, $currentY)
        $label.Size = New-Object Drawing.Size(700, 20)
        $form.Controls.Add($label)
        $currentY += 25

        $columnsPerRow = [math]::Floor(($formWidth - 2 * $padding) / $checkboxWidth)
        if ($columnsPerRow -lt 1) { $columnsPerRow = 1 }

        $appList = @($categories[$category].Keys)
        for ($i = 0; $i -lt $appList.Count; $i++) {
            $column = $i % $columnsPerRow
            $row = [math]::Floor($i / $columnsPerRow)

            $x = $padding + ($column * $checkboxWidth)
            $y = $currentY + ($row * $checkboxHeight)

            $checkbox = New-Object Windows.Forms.CheckBox
            $checkbox.Text = $appList[$i]
            $checkbox.Width = $checkboxWidth - 10
            $checkbox.Location = New-Object Drawing.Point($x, $y)

            $wingetId = $categories[$category][$appList[$i]]
            if ($installedWingetIds -contains $wingetId) {
                $checkbox.Enabled = $false
                $checkbox.Checked = $false
                $checkbox.ForeColor = [System.Drawing.Color]::Gray
            }

            $form.Controls.Add($checkbox)
            $checkboxes[$appList[$i]] = $checkbox
        }

        $rowsUsed = [math]::Ceiling($appList.Count / $columnsPerRow)
        $currentY += ($rowsUsed * $checkboxHeight) + 15
    }

	# Bouton Tout cocher / decocher
	$toggleAllButton = New-Object Windows.Forms.Button
	$toggleAllButton.Text = "Tout cocher"
	$toggleAllButton.Width = 60
	$toggleAllButton.Height = 40
	$toggleAllButton.Location = New-Object Drawing.Point(20, $currentY)
	$form.Controls.Add($toggleAllButton)
	
	$toggleAllButton.Add_Click({
		$shouldCheck = $checkboxes.Values | Where-Object { -not $_.Checked } | Measure-Object | Select-Object -ExpandProperty Count
		$newState = ($shouldCheck -gt 0)
	
		foreach ($cb in $checkboxes.Values) {
			$cb.Checked = $newState
		}
	
		$toggleAllButton.Text = if ($newState) { "Tout decocher" } else { "Tout cocher" }
	})

    # Bouton d’installation
    $installButton = New-Object Windows.Forms.Button
    $installButton.Text = "Installer les applications selectionnees"
	$installButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $installButton.Width = 200
    $installButton.Height = 40
    $installButton.Location = New-Object Drawing.Point(250, $currentY)
    $form.Controls.Add($installButton)

    # Bouton de mise a jour
    $updateButton = New-Object Windows.Forms.Button
    $updateButton.Text = "Mettre a jour les applications deja installees"
    $updateButton.Width = 160
    $updateButton.Height = 40
    $updateButton.Location = New-Object Drawing.Point(560, $currentY)
    $form.Controls.Add($updateButton)

	$appNamesById = @{}
	foreach ($category in $categories.Keys) {
		foreach ($appName in $categories[$category].Keys) {
			$id = $categories[$category][$appName]
			$appNamesById[$id] = $appName
	}
	}

    $installButton.Add_Click({
        $selectedApps = @()
        foreach ($category in $categories.Keys) {
            foreach ($appName in $categories[$category].Keys) {
                if ($checkboxes[$appName].Checked) {
                    $selectedApps += $categories[$category][$appName]
                }
            }
        }
    
        if ($selectedApps.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("Aucune application selectionnee.", "Info", "OK", "Information")
            return
        }
		
		foreach ($id in $selectedApps) {
			$appName = $appNamesById[$id]
			Write-Host "Installation de $($appName) ($($id))..." -ForegroundColor Cyan
			$install = Install-WinGetPackage -Id $id -Mode Silent -ErrorAction Stop

		if ($install.Status -eq "Ok") {
			Write-Host "Installation de $($appName) ($($id)) réussie." -ForegroundColor Green
		} else {
			Write-Host "Échec d'installation de $($appName) ($($id)) : $install.Status $install.ExtendedErrorCode" -ForegroundColor Red
		}
	}
    
        [System.Windows.Forms.MessageBox]::Show("Installation terminee", "Termine", "OK", "Information")
    })
    
    $updateButton.Add_Click({
        $UpdateAvailable = (Get-WinGetPackage | Where-Object IsUpdateAvailable).Id
    
        if ($UpdateAvailable.Count -gt 0) {
					
            foreach ($id in $UpdateAvailable) {
				$appName = $appNamesById[$id]
                Write-Host "Mise a jour de $($appName) ($($id))..." -ForegroundColor Cyan
                $update = Update-WinGetPackage -Id $id -Mode Silent -ErrorAction Stop
    
                if ($update.Status -eq "Ok") {
                    Write-Host "Mise a jour de $($appName) ($($id)) reussie." -ForegroundColor Green
                } else {
                    Write-Host "Echec de mise a jour de $($appName) ($($id)) :  $($update.Status) $($update.ExtendedErrorCode)" -ForegroundColor Red
                }
            }
			
			[System.Windows.Forms.MessageBox]::Show("Mise a jour terminee", "Succes", "OK", "Information")
        } else {
            Write-Host "Aucune mise a jour disponible." -ForegroundColor Cyan
			[System.Windows.Forms.MessageBox]::Show("Aucune mise a jour", "Succes", "OK", "Error")
        }
    })

	$form.Height = $updateButton.Bottom + 50

    [void]$form.ShowDialog()
}


# Verifie si WinGet est deja disponible
if (-not (Get-Module -ListAvailable -Name "Microsoft.WinGet.Client")) {
    Write-Host "Installation du module WinGet PowerShell depuis PSGallery..." -ForegroundColor Blue
    Install-PackageProvider -Name NuGet -Force | Out-Null
    Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
    Write-Host "Execution de Repair-WinGetPackageManager pour initialisation..." -ForegroundColor Blue
    Repair-WinGetPackageManager
    Write-Host "Installation de WinGet terminee." -ForegroundColor Green
}


Show-AppInstallerGUI