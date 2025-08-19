class Converter {

    [String]$source
    [String]$destination

    hidden [String]$ipAddress
    hidden [String]$hostName
    hidden [String]$groupName


    Converter([String]$source, [String]$destination) {
        $this.source = $source
        $this.destination = $destination
    }

    [Void]
    convert() {
        $this.removeDestinationIfExists()
        $this.writeDestination("/ip dns static")
        $data = $this.readSource()
        foreach ($line in $data) {
            $line = $this.convertOneLine($line)
            $this.writeDestination($line)
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
    [Object]
    readSource() {
        return Get-Content $this.source -Encoding UTF8 -ErrorAction Stop
    }

    hidden
    [Void]
    writeDestination([string]$line) {
        Add-Content -Path $this.destination -Value $line -Encoding UTF8 -ErrorAction Stop
    }

    hidden
    [String]
    convertOneLine([string]$line) {
        $line = $line.Trim()
        if ($line.Length -eq 0) {
            continue
        }

        $isComment = $line.StartsWith("#")
        if ($isComment) {
            $this.groupName = $line.TrimStart("#").TrimEnd(":").Trim()
            continue
        }

        $exploded = $line.Split(" ")
        $this.ipAddress = $exploded[0]
        $this.hostName = $exploded[1]

        return $this.formattedLine()
    }

    hidden
    [String]
    formattedLine() {
        if ($this.ipAddress -eq "" -or $this.hostName -eq "") {
            return ""
        }
        return "add address=$( $this.ipAddress ) name=$( $this.hostName ) type=A comment=`"$( $this.groupName )`""
    }

}
