function Example-ValidateScriptGuid {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript( {
                try {
                    [System.Guid]::Parse($_) | Out-Null
                    $true
                }
                catch {
                    throw "$_ is not a valid format. Valid value is a GUID format only."
                }
            })]
        [string]
        [System.String]
        # Filter items by property values
        ${CatalogId}
    )
}

Example-ValidateScriptGuid -CatalogId "b81b0d21-f5b9-4101-8490-5095f17a28e7"
