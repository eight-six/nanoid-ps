$Params = @{
    Path        = Join-Path $PSScriptRoot '..' 'src' 'nanoid-ps'
    NuGetApiKey = "$Env:NUGET_API_KEY"
}

Publish-Module @Params