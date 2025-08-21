class Downloader {

    static
    [Void]
    download([String]$source, [String]$destination) {
        Invoke-WebRequest -Uri $source -OutFile $destination -ErrorAction Stop
    }

}
