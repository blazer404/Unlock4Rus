class Constant {

    static
    [Void]
    create([String]$name, [String]$value) {
        $exists = Test-Path "variable:$( $name )"
        if (!$exists) {
            Set-Variable -Name $name -Value $value -Scope Global -Option Constant
        }
    }

}


[Constant]::create("HOSTS_SRC", "https://raw.githubusercontent.com/AvenCores/Unlock_AI_and_EN_Services_for_Russia/refs/heads/main/source/system/etc/hosts")
[Constant]::create("HOSTS_DST", ".\out\hosts")
[Constant]::create("STATIC_DNS_DST", ".\out\static_dns.rsc")
