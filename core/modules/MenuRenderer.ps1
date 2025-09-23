class MenuRenderer {

    static
    [Void]
    show() {
        Write-Host "- Choose what you want:"
        [MenuEntry]::new("1", "Convert only", "unblock").show()
        [MenuEntry]::new("2", "Convert only", "block").show()
        [MenuEntry]::new("3", "Convert", "both").show()
        [MenuEntry]::new("q", "Exit").show()
    }

}
