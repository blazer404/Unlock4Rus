class Menu {

    static
    [Void]
    show() {
        Write-Host "- Choose what you want:"
        [MenuItem]::new("1", "Convert only", "unblock").show()
        [MenuItem]::new("2", "Convert only", "block").show()
        [MenuItem]::new("3", "Convert", "both").show()
        [MenuItem]::new("q", "Exit").show()
    }

}
