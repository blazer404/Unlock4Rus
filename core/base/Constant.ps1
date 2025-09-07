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
