function Get-ALCompilerFromArtifact {
  #Requires -Module BcContainerHelper

  Param(
    [Parameter(Mandatory)]
    [string] $artifactUrl,
    [Parameter(Mandatory = $false)]
    [string] $folder,
    [Parameter(Mandatory = $false)]
    [switch] $createFolder
  )

  if ((Test-Path "$folder\alc.exe")) {
    return "$folder\alc.exe"
  }

  if ($createFolder) {
    $null = New-Item -ItemType Directory -Path $folder -Force
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
    
  $vsix = Get-ChildItem "$defaultFolder\platform\ModernDev\program files\Microsoft Dynamics NAV\*\AL Development Environment\ALLanguage.vsix"
  $tmp = "$folder\$(New-Guid)"
  $zip = "$folder\alc.zip"

  Copy-Item -Path $vsix -Destination $zip -Force
  Expand-Archive -Path $zip -DestinationPath "$tmp\" -Force
  Copy-Item -Path "$tmp\extension\bin\*" -Destination $folder -Recurse -Force
  Remove-Item -Path $zip -Force
  Remove-Item -Path "$tmp\" -Recurse -Force
 
  return "$folder\alc.exe"
}