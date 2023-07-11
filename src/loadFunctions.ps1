# Install-PackageProvider -Name NuGet -Force
# Install-Module -Name BcContainerHelper -Force

. "$PSScriptRoot\Get-ALCompilerFromArtifact.ps1"
. "$PSScriptRoot\Get-ALSymbolsFromArtifact.ps1"
. "$PSScriptRoot\Get-ALTestSymbolsFromArtifact.ps1"