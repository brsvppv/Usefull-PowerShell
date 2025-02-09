﻿function Get-DevOpsRepositories {
    param (
        [string]$DevOpsServer,
        [string]$Collection,
        [string]$Project,
        [string]$DestinationPath
    )

    if (!(Test-Path -Path $DestinationPath)) {
        New-Item -ItemType Directory -Path $DestinationPath | Out-Null
    }

    $uri = "$DevOpsServer/$Collection/$Project/_apis/git/repositories?api-version=6.0"
    $response = Invoke-RestMethod -Uri $uri -UseDefaultCredentials -Method Get

    foreach ($repo in $response.value) {
        $repoName = $repo.name
        $cloneUrl = $repo.remoteUrl
        $targetPath = Join-Path -Path $DestinationPath -ChildPath $repoName

        Write-Host "📁 Repo: $repoName"
        Write-Host "🌐 URL: $cloneUrl"

        if (Test-Path -Path $targetPath) {
            Write-Host "⚠️ The directory $targetPath already exists. Skipping clone."
            continue
        }

        try {
            git clone $cloneUrl $targetPath 2>&1 | ForEach-Object { Write-Host $_ }
        }
        catch {
            Write-Host "❗ Error cloning $repoName $($_.Exception.Message)"
        }
    }

    Write-Output "✅ Cloning completed in: $DestinationPath."
}
#Server URL
$Server = "https://devops.tvbg/" 
# SET COLLECTION
$Collection = "YouCollection" #
#SET PROJECT 
$Project = "YourProject"
#SET PATH - IF YOU WANT SPECIFIC PATH CHANGE EXAMPLE C:\PROJECTS"
$Path = Join-Path -Path "C:\DevOps" -ChildPath "$($Collection)\$($Project)"
# Example usage
Get-DevOpsRepositories -DevOpsServer $Server -Collection $Collection -Project $Project -DestinationPath  $Path