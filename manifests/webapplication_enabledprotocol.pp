define iisnetpipe::webapplication_enabledprotocol (
    $website,
    $webapplication,
    $ensure,
) {
    $importModule = 'Import-Module WebAdministration'

    $currentEnabledProtocolsCommand = sprintf('$currentEnabledProtocols = Get-ItemProperty -Path "IIS:\Sites\%s\%s" -Name enabledProtocols.Value', $website, $webapplication)
    $ifExistsCommand = sprintf('%s; if ($currentEnabledProtocols.split(",").Contains("net.pipe"))', $currentEnabledProtocolsCommand)

    if $ensure == present {
        $setEnabledProtocolsCommand = sprintf('Set-ItemProperty -Path "IIS:\Sites\%s\%s" -Name enabledProtocols -Value "$currentEnabledProtocols,net.pipe"', $website, $webapplication)
        $command = "${currentEnabledProtocolsCommand};${setEnabledProtocolsCommand}"

        exec { "add-netpipe-protocol-${website}/${webapplication}": 
            provider => powershell,
            command => "$importModule;$command",
            onlyif => "$importModule;$ifExistsCommand { exit 1 }",
        }   
    }
    else {
        $setEnabledProtocolsCommand = sprintf('
            $enabledProtocols = ""
            foreach ($protocol in $currentEnabledProtocols.Split(",") | ? { $_ -ne "net.pipe" }) {
                if ([String]::IsNullOrEmpty($enabledProtocols)) { $enabledProtocols = $protocol }
                else { $enabledProtocols += ",$protocol" }
            }

            Set-ItemProperty -Path "IIS:\Sites\%s\%s" -Name enabledProtocols -Value $enabledProtocols
        ', $website, $webapplication)

        $command = "${currentEnabledProtocolsCommand};${setEnabledProtocolsCommand}"

        exec { "remove-netpipe-protocol-${website}/${webapplication}": 
            provider => powershell,
            command => "$importModule;$command",
            onlyif => "$importModule;$ifExistsCommand { exit 0 } exit 1",
        }
    }
}