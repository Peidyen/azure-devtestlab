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
    # An existing VM Resource ID.
    $VMId,

    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory=$true)]
    [string]
    # Name of the new VM template to create.
    $VMTemplateName,

    [ValidateNotNull()]
    [string]
    # Details about the new VM template being created.
    $VMTemplateDescription = "",
    
    [string]
    # An output variable that captures the newly created VM Template's resource ID.
    $OutputVariableVMTemplateId
)    

##################################################################################################

Write-Host "================"
Write-Host "Parameter values"
Write-Host "================"
Write-Host $("`$ConnectedServiceName : " + $ConnectedServiceName) 
Write-Host $("`$VMId : " + $VMId)
Write-Host $("`$VMTemplateName : " + $VMTemplateName)
Write-Host $("`$VMTemplateDescription : " + $VMTemplateDescription)
Write-Host $("`$OutputVariableVMTemplateId : " + $OutputVariableVMTemplateId)
Write-Host "================"

# Let us import the cmdlets for DevTestLab
$ModulePath = Join-Path -Path $PSScriptRoot -ChildPath "DtlCmdlets\101-dtl-create-lab\Cmdlets.DevTestLab.ps1" -Resolve

Write-Host $("Importing DTL cmdlets from '" + $ModulePath + "' ...")
Import-Module $ModulePath -Verbose -Force
Write-Host "Success."

# Get the specified VM.
Write-Host $("Getting VM with ID '" + $VMId + "' ...")
$VM = Get-AzureDtlVirtualMachine -VMId $VMId -Verbose
Write-Host "Success."

# Create the VM Template.
Write-Host $("Creating VM Template '" + $VMTemplateName + "' ...")
$VMTemplate = New-AzureDtlVMTemplate -VM $VM -VMTemplateName "$VMTemplateName" -VMTemplateDescription "$VMTemplateDescription" -Verbose
Write-Host "Success."

if ($OutputVariableVMTemplateId)
{
    # Capture the VM's FQDN in the output variable
    Write-Host $("Creating variable '" + $OutputVariableVMTemplateId + "' with value '" + $VMTemplate.ResourceId + "'")
    Set-TaskVariable -Variable $OutputVariableVMTemplateId -Value $VMTemplate.ResourceId
    Write-Host "Success."
}