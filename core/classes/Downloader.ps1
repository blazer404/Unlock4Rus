class Downloader {

    static
    [Void]
    download([String]$source, [String]$destination) {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $source -OutFile $destination -ErrorAction Stop
    }

}
