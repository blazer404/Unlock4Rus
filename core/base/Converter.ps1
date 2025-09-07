class Converter {

    [String]$source
    [String]$destination
    [String]$mode

    hidden [String]$ipAddress
    hidden [String]$hostName
    hidden [String]$groupName

    hidden[Array]$processedHostNames
    hidden[String]$commentPrefix


    Converter([String]$source, [String]$destination, [String]$mode) {
        $this.source = $source
        $this.destination = $destination
        $this.mode = $mode

        $this.ipAddress = $this.hostName = $this.groupName = ""
        $this.processedHostNames = @()
        $this.commentPrefix = "U4R"
    }

    [Void]
    convert() {
        Write-Host "  Mode: $( $this.mode )" -ForegroundColor Yellow

        $this.removeDestinationIfExists()
        $this.writeScriptStart()
        $data = $this.readSource()
        foreach ($line in $data) {
            $isComment = $line.StartsWith("#")
            if ($isComment) {
                $this.writeToDestination("`n$line")
            }
            $line = $this.convertOneLine($line)
            if ($line.Length -eq 0) {
                continue
            }
            $this.writeToDestination($line)
        }
    }

    hidden
    [Void]
    removeDestinationIfExists() {
        if (Test-Path $this.destination) {
            Remove-Item $this.destination -Force -ErrorAction Stop
        }
    }

    hidden
    [Void]
    writeScriptStart() {
        $escapedCommentPrefix = $this.escapedString($this.commentPrefix)
        $this.writeToDestination("/ip dns static")
        $this.writeToDestination("remove [find where comment~`"^$( $escapedCommentPrefix )`"]")
    }

    hidden
    [Object]
    readSource() {
        return Get-Content $this.source -Encoding UTF8 -ErrorAction Stop
    }

    hidden
    [Void]
    writeToDestination([String]$line) {
        $encoding = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::AppendAllText($this.destination, "$line`r`n", $encoding)
    }

    hidden
    [String]
    convertOneLine([String]$line) {
        $line = $line.Trim()
        if ($line.Length -eq 0) {
            return ""
        }

        $isComment = $line.StartsWith("#")
        if ($isComment) {
            $this.groupName = $line.TrimStart("#").TrimEnd(":").Trim()
            return ""
        }

        $exploded = $line.Split(" ")
        $this.ipAddress = $exploded[0]
        $this.hostName = $exploded[1]

        if ($this.processedHostNames -contains $this.hostName) {
            return ""
        }
        $this.processedHostNames += $this.hostName

        return $this.formattedLine()
    }

    hidden
    [String]
    escapedString([String]$string) {
        $bytes = [System.Text.Encoding]::GetEncoding(1251).GetBytes($string)
        $escaped = ($bytes | ForEach-Object { "\" + $_.ToString("X2") }) -join ""
        return $escaped
    }

    hidden
    [String]
    formattedLine() {
        if ($this.ipAddress -eq "" -or $this.hostName -eq "") {
            return ""
        }
        if (!$this.isValidMode()) {
            return ""
        }
        $comment = "$( $this.commentPrefix ) $( $this.groupName )"
        $comment = $this.escapedString($comment)
        if ($this.ipAddress -eq "0.0.0.0") {
            return "add cname=0.0.0.0 name=$( $this.hostName ) type=CNAME comment=`"$( $comment )`""
        }
        return "add address=$( $this.ipAddress ) name=$( $this.hostName ) type=A comment=`"$( $comment )`""
    }

    hidden
    [Boolean]
    isValidMode() {
        return $this.mode -eq "Both" -Or
               ($this.mode -eq "Unblock" -And $this.ipAddress -ne "0.0.0.0") -Or
               ($this.mode -eq "Block" -And $this.ipAddress -eq "0.0.0.0")
    }

}
