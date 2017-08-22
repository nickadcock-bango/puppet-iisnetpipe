iisnetpipe::webapplication_enabledprotocol { $app:
    website => $site,
    webapplication => $app,
    ensure => present,
}