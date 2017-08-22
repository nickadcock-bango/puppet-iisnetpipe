define iisnetpipe::website_enabledprotocol (
    $website,
    $ensure,
) {
    $importModule = 'Import-Module WebAdministration'

    $currentEnabledProtocolsCommand = sprintf('$currentEnabledProtocols = Get-ItemProperty -Path "IIS:\Sites\%s" -Name enabledProtocols', $website)
    $ifExistsCommand = sprintf('%s; if ($currentEnabledProtocols.split(",").Contains("net.pipe"))', $currentEnabledProtocolsCommand)

    if $ensure == present {
        $setEnabledProtocolsCommand = sprintf('Set-ItemProperty -Path "IIS:\Sites\%s" -Name enabledProtocols -Value "$currentEnabledProtocols,net.pipe"', $website)
        $command = "${currentEnabledProtocolsCommand};${setEnabledProtocolsCommand}"

        exec { 'add-netpipe': 
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

            Set-ItemProperty -Path "IIS:\Sites\%s" -Name enabledProtocols -Value $enabledProtocols
        ', $website)

        $command = "${currentEnabledProtocolsCommand};${setEnabledProtocolsCommand}"

        exec { 'remove-netpipe': 
            provider => powershell,
            command => "$importModule;$command",
            onlyif => "$importModule;$ifExistsCommand { exit 0 } exit 1",
        }
    }
}