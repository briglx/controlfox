function Confirm-Credentials {

   if ([string]::IsNullOrWhiteSpace($Env:AZURE_AUTH)){
      Throw "Missing Azure Auth. Ensure Environment Variable AZURE_AUTH is set"        
   }
   
   $azure_auth = $Env:AZURE_AUTH | ConvertFrom-Json

   if ([string]::IsNullOrWhiteSpace($azure_auth.clientId)){
      Throw "Missing Azure Auth ClientID. Ensure Environment Variable AZURE_AUTH is set"        
   }
   if ([string]::IsNullOrWhiteSpace($azure_auth.clientSecret)){
      Throw "Missing Azure Auth Client Secret. Ensure Environment Variable AZURE_AUTH is set"        
   }
   if ([string]::IsNullOrWhiteSpace($azure_auth.tenantId)){
      Throw "Missing Azure Auth Tenant. Ensure Environment Variable AZURE_AUTH is set"        
   }
}

# Validate Azure Credentials
Confirm-Credentials

# Authenticate Service Principal
$azure_auth = $Env:AZURE_AUTH | ConvertFrom-Json
$secureClientSecret = ConvertTo-SecureString $azure_auth.clientSecret -AsPlainText -Force
$pscredential = New-Object System.Management.Automation.PSCredential($azure_auth.clientId, $secureClientSecret)
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $azure_auth.tenantId

# Get all subscriptions
$subscriptions = Get-AzSubscription
#Use this script to limit to a specific tenant ID (Example is for the HON master tenant)
#$subscriptions = Get-AzSubscription -TenantId 96ece526-9c7d-48b0-8daf-8b93c90a5d18

#Use this script to collect from a list of subscriptions. Always use "SubscriptionId" cloumn name and Sub ID values
#$infilepath = "/Users/" + $sdate + ".csv"
#$subscriptions = (Get-Content -Path $infilepath)

$report = @()

ForEach ($vsub in $subscriptions)
{
   Set-AzContext $vsub.SubscriptionId
      $logprofile = Get-AzLogProfile -Name default -ErrorAction Ignore

      $info = ""| Select-Object Subscription_Name, Subscription_Id, Tenant_Id, Subscription_State, EH_NameSpace
      $info.Subscription_Name = $vsub.Name
      $info.Subscription_Id = $vsub.SubscriptionId
      $info.Tenant_Id = $vsub.TenantId
      $info.Subscription_State = $vsub.State
      $trimmer = $logprofile.ServiceBusRuleId
      if ($trimmer) { $info.EH_NameSpace = $trimmer.Split("/")[8] }
      if (!$trimmer) { $info.EH_NameSpace = "No default Logprofile defined"}

      $report+=$info
}

#write-host $report
$date = (Get-Date -format "yyyyMMddHHmm")
$outfilepath = "Az.EventHub.NameSpace.Settings-" + $date + ".csv"
$report |Export-Csv -Path $outfilepath -Delimiter "," -Force -NoTypeInformation