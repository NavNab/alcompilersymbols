function Get-ALTestSymbolsFromArtifact {
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

  $defaultFolder = Resolve-Path "$($bcContainerHelperConfig.bcartifactsCacheFolder)\$type\$version\platform\Applications"
  if (($null -eq $folder) -or ('' -eq $folder)) {
    $folder = $defaultFolder
  }
  else {
    $folder = Resolve-Path $folder
  }

  $sources = "$defaultFolder\testframework\", "$defaultFolder\BaseApp\Test\", "$defaultFolder\system application\Test\"
  foreach ($source in $sources) {
    $symbols = Get-ChildItem -Path $source -Recurse -Filter '*.app'
    foreach ($symbol in $symbols) {
      Write-Host "Copying $($symbol.FullName) to $folder" -ForegroundColor Green
      Copy-Item -Path $symbol.FullName -Destination $folder -Force
    }
  }

  return $folder
}