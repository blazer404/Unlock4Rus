class MenuItem {
    $key
    $text
    $extraInfo = ""

    MenuItem([String]$key, [String]$text) {
        $this.key = $key
        $this.text = $text
    }

    MenuItem([String]$key, [String]$text, [String]$extraInfo) {
        $this.key = $key
        $this.text = $text
        $this.extraInfo = $extraInfo
    }

    [Void]
    show() {
        Write-Host "  [" -NoNewline
        Write-Host "$( $this.key )" -ForegroundColor Yellow -NoNewline
        Write-Host "] " -NoNewline

        if ($this.extraInfo) {
            Write-Host "$( $this.text )" -NoNewline
            Write-Host " $( $this.extraInfo )" -ForegroundColor DarkGreen
        } else {
            Write-Host "$( $this.text )"
        }
    }

}
