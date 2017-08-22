iisnetpipe::webapplication_enabledprotocol { $app:
    website => $site,
    webapplication => $app,
    ensure => absent,
}

iisnetpipe::website_enabledprotocol { $app:
    website => $site,
    ensure => absent,
}

iisnetpipe::website_binding { $bindinginformation: 
    website => $site,
    bindinginformation => $bindinginformation,
    ensure => absent,
}