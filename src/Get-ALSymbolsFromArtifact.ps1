function Get-ALSymbolsFromArtifact {
  #Requires -Module BcContainerHelper
        
  Param(
    [Parameter(Mandatory)]
    [string] $artifactUrl,
    [Parameter(Mandatory = $false)]
    [string] $folder,
    [Parameter(Mandatory = $false)]
    [switch] $createFolder
  )

  if ($createFolder) {
    $null = New-Item -ItemType Directory -Path "$folder" -Force
  }
    
  $null = Import-Module -Name 'BcContainerHelper'

  Download-Artifacts -artifactUrl $artifactUrl -includePlatform
  $version = Split-Path (Split-Path $artifactUrl) -Leaf
  $type = Split-Path (Split-Path (Split-Path $artifactUrl)) -Leaf

  $defaultFolder = Resolve-Path "$($bcContainerHelperConfig.bcartifactsCacheFolder)\$type\$version"
  if (($null -eq $folder) -or ('' -eq $folder)) {
    $folder = $defaultFolder
  }
  else {
    $folder = Resolve-Path $folder
  }

  $sourceSystem = Get-ChildItem "$defaultFolder\platform\ModernDev\program files\Microsoft Dynamics NAV\*\AL Development Environment\System.app"
  $sourceMicrosoftApplication = Get-ChildItem "$defaultFolder\platform\Applications\Application\Source\Microsoft_Application.app"
  $sourceMicrosoftBaseApplication = Get-ChildItem "$defaultFolder\platform\Applications\BaseApp\Source\Microsoft_Base Application.app"
  $sourceMicrosoftSystemApplication = Get-ChildItem "$defaultFolder\platform\Applications\system application\Source\Microsoft_System Application.app"

  $system = "$folder\Microsoft_$($sourceSystem.BaseName)_$version.app"
  $microsoftApplication = "$folder\$($sourceMicrosoftApplication.BaseName)_$version.app"
  $microsoftBaseApplication = "$folder\$($sourceMicrosoftBaseApplication.BaseName)_$version.app"
  $microsoftSystemApplication = "$folder\$($sourceMicrosoftSystemApplication.BaseName)_$version.app"

  if ((Test-Path "$system") -and (Test-Path "$microsoftApplication") -and (Test-Path "$microsoftBaseApplication") -and (Test-Path "$microsoftSystemApplication")) {
    return $folder
  }
    
  Copy-Item -Path $sourceSystem -Destination $system -Force
  Copy-Item -Path $sourceMicrosoftApplication -Destination $microsoftApplication -Force
  Copy-Item -Path $sourceMicrosoftBaseApplication -Destination $microsoftBaseApplication -Force
  Copy-Item -Path $sourceMicrosoftSystemApplication -Destination $microsoftSystemApplication -Force

  return $folder
}