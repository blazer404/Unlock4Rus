class MenuRenderer {

    static
    [Void]
    show() {
        Write-Host "- Choose what you want:"

        [MenuEntry]::new("1", "Convert", "unblocking").show()
        [MenuEntry]::new("2", "Convert", "blocking").show()
        [MenuEntry]::new("3", "Convert", "all").show()
        [MenuEntry]::new("4", "Download", "hosts").show()
        [MenuEntry]::new("q", "Exit").show()
    }

}
