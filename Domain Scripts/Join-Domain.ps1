function Join-Domain($Domain, $Server) {
    Add-Computer -DomainName $Domain -Server $Server -PassThru -Verbose
}
Join-Domain("example.com", 'DomainHostName')