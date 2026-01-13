using module ".\core\Autoloader.ps1"

Param([string]$M = "")

function Main() {
    switch ($M) {
        "1" { ProcessHosts -mode "Unblock" }
        "2" { ProcessHosts -mode "Block" }
        "3" { ProcessHosts -mode "Both" }
        "4" { ProcessHosts -mode "Download" }
        Default { ShowMenu }
    }
}

function ShowMenu() {
    while ($true) {
        Clear-Host
        [LogoRenderer]::show()
        [MenuRenderer]::show()
        $choice = Read-Host "`n- Enter your choice"
        switch ($choice) {
            "1" { ProcessHosts -mode "Unblock" }
            "2" { ProcessHosts -mode "Block" }
            "3" { ProcessHosts -mode "Both" }
            "4" { ProcessHosts -mode "Download" }
            "q" { ProcessExit }
            Default { break }
        }
    }
}

function ProcessHosts([String]$mode) {
    Clear-Host
    [LogoRenderer]::show()
    DownloadHosts
    if ($mode -ne "Download") {
        ConvertHosts -mode $mode
    }
    UnloadModules
    Done
    exit $CODE_SUCCESS
}

function ProcessExit() {
    UnloadModules
    exit $CODE_SUCCESS
}

function DownloadHosts() {
    Write-Host
    Write-Host "- Downloading hosts file..."
    try {
        [Downloader]::download($HOSTS_SRC, $HOSTS_DST)
    } catch {
        Write-Host "  Hosts file download failed!" -ForegroundColor Red
        Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
        exit $CODE_ERROR_DOWNLOAD
    }
    Write-Host "  Hosts file downloaded to `"$( $HOSTS_DST )`"" -ForegroundColor Green
}

function ConvertHosts([String]$mode) {
    Write-Host
    Write-Host "- Converting hosts file..."
    try {
        [HostsConverter]::new($HOSTS_DST, $STATIC_DNS_DST, $mode).convert()
    } catch {
        Write-Host "  Hosts file conversion failed!" -ForegroundColor Red
        Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
        exit $CODE_ERROR_CONVERSION
    }
    Write-Host "  Hosts file converted to `"$( $STATIC_DNS_DST )`"" -ForegroundColor Green
}

function UnloadModules() {
    Write-Host
    try {
        Import-Module "$PSScriptRoot\core\Unloader.ps1" -Force -ErrorAction Stop -Scope Global
    } catch {
        Write-Host "  Unload modules failed!" -ForegroundColor Red
        Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
        exit $CODE_ERROR_UNLOAD
    }
}

function Done() {
    Write-Host
    Write-Host "  Done! Press Any key to exit..." -ForegroundColor Cyan
    Read-Host
}


Main
