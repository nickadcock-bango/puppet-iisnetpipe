iisnetpipe::webapplication_enabledprotocol { $app:
    website => $site,
    webapplication => $app,
    ensure => present,
}

iisnetpipe::website_enabledprotocol { $app:
    website => $site,
    ensure => present,
}

iisnetpipe::website_binding { $bindinginformation: 
    website => $site,
    bindinginformation => $bindinginformation,
    ensure => present,
}