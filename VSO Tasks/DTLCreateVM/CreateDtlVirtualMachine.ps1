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
    # An existing lab in which the VM will be created (please use the Get-AzureDtlLab cmdlet to get this lab object).
    $LabName,

    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory=$true)]
    [string]
    # An existing VM template which will be used to create the new VM (please use the Get-AzureDtlVmTemplate cmdlet to get this VMTemplate object).
    # Note: This VM template must exist in the lab identified via the '-LabName' parameter.
    $VMTemplateName,

    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory=$true)]
    [string]
    # The name of VM to be created.
    $VMName,

    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory=$true)]
    [string]
    # The size of VM to be created ("Standard_A0", "Standard_D1_v2", "Standard_D2" etc).
    $VMSize,

    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory=$true)]
    [string]
    # An output variable that captures the newly created VM's Id.
    $OutputVariableId,

    [string]
    # An output variable that captures the newly created VM's FQDN.
    $OutputVariableFQDN
)    

##################################################################################################

Write-Host "================"
Write-Host "Parameter values"
Write-Host "================"
Write-Host $("`$ConnectedServiceName : " + $ConnectedServiceName) 
Write-Host $("`$LabName : " + $LabName) 
Write-Host $("`$VMTemplateName : " + $VMTemplateName)
Write-Host $("`$VMName : " + $VMName) 
Write-Host $("`$VMSize : " + $VMSize) 
Write-Host $("`$OutputVariableId : " + $OutputVariableId)
Write-Host $("`$OutputVariableFQDN : " + $OutputVariableFQDN)
Write-Host "================"

# Let us import the cmdlets for DevTestLab
$ModulePath = Join-Path -Path $PSScriptRoot -ChildPath "DtlCmdlets\101-dtl-create-lab\Cmdlets.DevTestLab.ps1" -Resolve

Write-Host $("Importing DTL cmdlets from '" + $ModulePath + "' ...")
Import-Module $ModulePath -Verbose -Force
Write-Host "Success."

# Now let us get the specified lab
Write-Host $("Getting lab '" + $LabName + "' ...")
$Lab = Get-AzureDtlLab -LabName $LabName -Verbose
Write-Host "Success."

# Now let us get the specified VM template
Write-Host $("Getting VM template '" + $VMTemplateName + "' ...")
$VMTemplate = Get-AzureDtlVMTemplate -Lab $Lab -VMTemplateName $VMTemplateName -Verbose
Write-Host "Success."

# Now let us create the VM
Write-Host $("Creating VM '" + $VMName + "' ...")
$VM = New-AzureDtlVirtualMachine -VMName $VMName -VMSize $VMSize -Lab $Lab -VMTemplate $VMTemplate -Verbose
Write-Host "Success."

# Capture the VM's Id in the output variable
Write-Host $("Creating variable '" + $OutputVariableId + "' with value '" + $VM.ResourceId + "'")
Set-TaskVariable -Variable $OutputVariableId -Value $VM.ResourceId
Write-Host "Success."

if ($OutputVariableFQDN)
{
    # Capture the VM's FQDN in the output variable
    Write-Host $("Creating variable '" + $OutputVariableFQDN + "' with value '" + $VM.Properties.Vms[0].Fqdn + "'")
    Set-TaskVariable -Variable $OutputVariableFQDN -Value $VM.Properties.Vms[0].Fqdn 
    Write-Host "Success."
}