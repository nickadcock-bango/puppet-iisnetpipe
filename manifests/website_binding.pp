define iisnetpipe::website_binding (
    $website,
    $bindinginformation,
    $ensure,
) {
    $importModule = 'Import-Module WebAdministration'

    $matchingBindingCommand = sprintf('
        $matchingBindings = 
        (Get-ItemProperty -Path IIS:\Sites\webservices.internal.local.bango.org -Name bindings.Collection) | 
        ? { $_.protocol -eq "net.pipe" -and $_.bindingInformation -eq "%s" }
    ', $bindinginformation)
    $ifExistsCommand = sprintf('%s; if ($matchingBindings.Count -eq 1)', $matchingBindingCommand)

    if $ensure == present {
        $command = sprintf('New-ItemProperty -Path IIS:\Sites\%s -Name bindings -Value @{protocol = "net.pipe"; bindingInformation = "%s"}', $website, $bindinginformation)
        exec { "add-netpipe-binding-${website} - ${bindinginformation}": 
            provider => powershell,
            command => "$importModule;$command",
            onlyif => "$importModule;$ifExistsCommand { exit 1 }",
        }   
    }
    else {
        $command = sprintf('
            $path = "IIS:\Sites\%s"
            $prop = (Get-ItemProperty -Path $path -Name bindings).Collection | ? { $_.protocol -ne "net.pipe" -or $_.bindingInformation -ne "%s" }
            Set-ItemProperty -Path $path -Name bindings -Value $prop
        ', $website, $bindinginformation)

        exec { "remove-netpipe-binding-${website} - ${bindinginformation}": 
            provider => powershell,
            command => "$importModule;$command",
            onlyif => "$importModule;$ifExistsCommand { exit 0 } exit 1",
        }
    }
}