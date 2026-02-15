class HostsConverter {

    [String]$source
    [String]$destination
    [String]$mode

    hidden [String]$ipAddress
    hidden [String]$hostName
    hidden [String]$groupName

    hidden [System.Collections.Generic.HashSet[String]]$processedHostNames
    hidden [String]$commentPrefix


    HostsConverter([String]$source, [String]$destination, [String]$mode) {
        $this.source = $source
        $this.destination = $destination
        $this.mode = $mode

        $this.validateExecutionMode # throws on error

        $this.ipAddress = ""
        $this.hostName = ""
        $this.groupName = ""
        $this.processedHostNames = [System.Collections.Generic.HashSet[string]]::new()
        $this.commentPrefix = "U4R"
    }

    hidden
    [Void]
    validateExecutionMode() {
        $supportedModes = @("Unblock", "Block", "Both")
        if ($this.mode -notin $supportedModes) {
            throw "Unsupported conversion mode: $( $this.mode )"
        }
    }


    [Void]
    convert() {
        Write-Host "  Mode: $( $this.mode )" -ForegroundColor Yellow

        $this.removeDestinationFileIfExists()
        $this.writeScriptStartLines()
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
    removeDestinationFileIfExists() {
        if (Test-Path $this.destination) {
            Remove-Item $this.destination -Force -ErrorAction Stop
        }
    }

    hidden
    [Void]
    writeScriptStartLines() {
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

        $isValidHostRecord = $this.tryReadHostRecord($line);
        if (-not $isValidHostRecord) {
            return ""
        }

        $isDuplicate = $this.processedHostNames.Contains($this.hostName)
        if ($isDuplicate) {
            return ""
        }

        $this.processedHostNames.Add($this.hostName) | Out-Null

        return $this.formattedLine()
    }

    hidden
    [Boolean]
    tryReadHostRecord([String]$line) {
        $exploded = $line.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
        $this.ipAddress = $exploded[0]
        $this.hostName = $exploded[1]
        return $this.ipAddress -ne "" -and $this.hostName -ne ""
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
        return $this.mode -eq "Both" -or
               ($this.mode -eq "Unblock" -and $this.ipAddress -ne "0.0.0.0") -or
               ($this.mode -eq "Block" -and $this.ipAddress -eq "0.0.0.0")
    }

}
