$Params = @{
    Path        = "$HOME\source\repos\nanoid-ps\src\nanoid-ps"
    NuGetApiKey = "$Env:NUGET_API_KEY"
}

Publish-Module @Params