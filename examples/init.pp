# Adds, if not already exists, the net.pipe protocol to the webapplication's enabled protocols
iisnetpipe::webapplication_enabledprotocol { $app:
    website => $site,
    webapplication => $app,
    ensure => present,
}

# Removes, if exists, the net.pipe protocol from the webapplication's enabled protocols
iisnetpipe::webapplication_enabledprotocol { $app:
    website => $site,
    webapplication => $app,
    ensure => absent,
}

# Adds, if not already exists, the net.pipe protocol to the websites's enabled protocols
iisnetpipe::website_enabledprotocol { $app:
    website => $site,
    ensure => present,
}

# Removes, if exists, the net.pipe protocol from the websites's enabled protocols
iisnetpipe::website_enabledprotocol { $app:
    website => $site,
    ensure => absent,
}

# Adds, if not already exists, a net.pipe binding to the website
iisnetpipe::website_binding { $bindinginformation: 
    website => $site,
    bindinginformation => $bindinginformation,
    ensure => present,
}

# Removes, if exists, a net.pipe binding from the website
iisnetpipe::website_binding { $bindinginformation: 
    website => $site,
    bindinginformation => $bindinginformation,
    ensure => absent,
}