$Subscription = "Microsoft Azure Sponsorship - Reco"
$AcrName = "recomaticsworkflow"

Write-Warning "Logging in to purge $($AcrName)..."
az login
az account set --subscription $Subscription
az acr login --name $AcrName

$Repositories = @(
    'externals/nginx-proxy-manager'
)
Foreach ($Repository IN $Repositories) {
	Write-Warning "Purging repository $($Repository)..."
	
    $DigestsToDelete = az acr repository show-manifests --name $AcrName --repository $Repository --query "[?tags[0]==null].digest" -o tsv 
    Foreach ($DigestToDelete IN $DigestsToDelete) {
        az acr repository delete --name $AcrName --image $Repository@$DigestToDelete --yes
    }
	
	Write-Warning "State after purging repository $($Repository):"
	az acr repository show-manifests --name $AcrName --repository $Repository
}
