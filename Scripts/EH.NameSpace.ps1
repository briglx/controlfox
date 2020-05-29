#Connect-AzAccount

$date = (Get-Date -format "yyyyMMddHHmm")
$outfilepath = "/Users/H274270/Documents/OneDrive - Honeywell/HON-Documents/DPS/Scripts/Output/Az.EventHub.NameSpace.Settings-" + $date + ".csv"
$report = @()


$subscriptions = Get-AzSubscription
#Use this script to limit to a specific tenant ID (Example is for the HON master tenant)
#$subscriptions = Get-AzSubscription -TenantId 96ece526-9c7d-48b0-8daf-8b93c90a5d18

#Use this script to collect from a list of subscriptions. Always use "SubscriptionId" cloumn name and Sub ID values
#$infilepath = "/Users/" + $sdate + ".csv"
#$subscriptions = (Get-Content -Path $infilepath)

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

$report |Export-Csv -Path $outfilepath -Delimiter "," -Force -NoTypeInformation