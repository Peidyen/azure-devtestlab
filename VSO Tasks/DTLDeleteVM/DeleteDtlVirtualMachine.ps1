##################################################################################################
#
# Parameters to this script file.
#

[CmdletBinding()]
Param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)]
    [String]
    # The authenticated Azure service endpoint.
    $ConnectedServiceName,

    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory=$true)]
    [string]
    # The Id of VM to be deleted.
    $VMId
)    

##################################################################################################

Write-Host "================"
Write-Host "Parameter values"
Write-Host "================"
Write-Host $("`$ConnectedServiceName : " + $ConnectedServiceName) 
Write-Host $("`$VMId : " + $VMId) 
Write-Host $("`$SubscriptionId : " + $SubscriptionId) 
Write-Host $("`$ClientId : " + $ClientId) 
Write-Host $("`$TenantId : " + $TenantId) 
Write-Host "================"

# Let us import the cmdlets for DevTestLab
$ModulePath = Join-Path -Path $PSScriptRoot -ChildPath "DtlCmdlets\101-dtl-create-lab\Cmdlets.DevTestLab.ps1" -Resolve

Write-Host $("Importing DTL cmdlets from '" + $ModulePath + "' ...")
Import-Module $ModulePath -Verbose -Force
Write-Host "Success."

# Now let us delete the specified VM
Write-Host $("Deleting VM with Id = '" + $VMId + "' ...")
Remove-AzureDtlVirtualMachine -VMId $VMId -Verbose
Write-Host "Success."