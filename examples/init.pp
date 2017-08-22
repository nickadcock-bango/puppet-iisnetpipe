iisnetpipe::webapplication_enabledprotocol { $app:
    website => $site,
    webapplication => $app,
    ensure => present,
}

iisnetpipe::website_enabledprotocol { $app:
    website => $site,
    ensure => present,
}