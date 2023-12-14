$Params = @{
    Path        = Join-Path $PSScriptRoot 'nanoid-ps' 'src' 'nanoid-ps'
    NuGetApiKey = "$Env:NUGET_API_KEY"
}

Publish-Module @Params