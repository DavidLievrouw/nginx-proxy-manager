$InformationPreference = 'Continue'

$Subscription = "Microsoft Azure Sponsorship - Reco"
$AcrName = "recomaticsworkflow"
$Repository = "nginx-proxy-manager"
$BaseTag = Get-Content "$PSScriptRoot\..\.version" -First 1
$AcrNameLower = $AcrName.toLower()

Write-Information "Logging in to push $($Repository)..."
az login
az account set --subscription $Subscription
az acr login --name $AcrName

$Tags = Get-Content "$PSScriptRoot\..\.tags" | Select-Object -Unique
if ($null -ne $Tags) {
    $CommaSeparatedTags = [string]::join(",", $Tags)
    Write-Host "The following tags will be set: ${CommaSeparatedTags}"
    
    ForEach ($Tag in $Tags) {
        $TaggedImageFullName = "$($AcrNameLower).azurecr.io/externals/$($Repository):$($BaseTag)-$($Tag)"
        Write-Information "Tagging image $($Repository):$($BaseTag) as '$($TaggedImageFullName)' locally..."
        docker tag "$($Repository):$($BaseTag)" $TaggedImageFullName
        Write-Information "Pushing $($TaggedImageFullName)..."
        docker push $TaggedImageFullName
    }
}
