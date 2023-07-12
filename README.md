# How to download AL Symbols 'offline' from artifact

## Introduction

Download AL Symbols! If you are involved in developing apps (PTE or AppSource) for Microsoft Dynamics 365 Business Central, you're probably familiar with this command:

![Download AL Symbols](https://raw.githubusercontent.com/NavNab/alcompilersymbols/main/src/img/downloadSymbols.png?token=GHSAT0AAAAAACEQ2KQ226HDYMVFCKAM2LIAZFN2ZEA "Download AL Symbols")

This command allows you to download the symbols for the app you're currently working on. However, what if you want to automate this process?

## ~~My~~ Use case

In my scenario, I need to compile and build the app in a build pipeline using Docker. This is a common requirement, but to accomplish this, I first need to download the symbols and then invoke the `Compile-AppInNavContainer` command from the [BcContainerHelper](https://www.powershellgallery.com/packages/BcContainerHelper/) module.
As you may know, the `Compile-AppInNavContainer` command requires a running container. Consequently, creating a container is a time-consuming process. To minimize build time, it would be beneficial to skip the container creation step. I would like to share my solution with you.

## Solution

I created a PowerShell script that downloads the symbols for you. You can find the script in my [github](https://github.com/NavNab/alcompilersymbols). The script is named [Get-ALSymbolsFromArtifact.ps1](https://github.com/NavNab/alcompilersymbols/blob/main/src/Get-ALSymbolsFromArtifact.ps1).

Additionally, I have created two other scripts for downloading symbols for the test app and the compiler. You can locate them on the same [repo](https://github.com/NavNab/alcompilersymbols):

- [Get-ALTestSymbolsFromArtifact.ps1](https://github.com/NavNab/alcompilersymbols/blob/main/src/Get-ALTestSymbolsFromArtifact.ps1)
- [Get-ALCompilerFromArtifact.ps1](https://github.com/NavNab/alcompilersymbols/blob/main/src/Get-ALCompilerFromArtifact.ps1)

***Note***: The word 'offline' in the title is enclosed in quotes because the script does not actually download the symbols; instead, it copies them from the artifact. Therefore, an internet connection is necessary to download the artifact ;).

## How to use

To utilize this script, you need to have the BcContainerHelper module installed (naturally ;)). The usage is straightforward. Simply call the script with the artifact URL as a parameter. The script will download the symbols and place them in the specified folder. You can also use the `-createFolder`  switch to automatically create the folder if it does not already exist.

```powershell
$artifactUrl = Get-BCArtifactUrl -type 'OnPrem' -country 'us' -version '22.3' -latest
Get-ALSymbolsFromArtifact -artifactUrl $artifactUrl -folder 'C:\temp\symbols' -createFolder
Get-ALTestSymbolsFromArtifact -artifactUrl $artifactUrl -folder 'C:\temp\symbols' -createFolder
Get-ALCompilerFromArtifact -artifactUrl $artifactUrl -folder 'C:\temp\compiler' -createFolder
```

If you omit the `-folder` parameter, the script will download the symbols (or compiler) and place them in the `bcartifactsCacheFolder` folder.

## How to improve

The scripts are a simplified version of what we currently use in my company. If you want to improve the scripts, you can add the following features:

- Add support for downloading symbols for app based on the app.json file to handle dependencies.
- Add support for downloading symbols for multiple apps.
- ...

## Conclusion

I hope you find the scripts useful. If you have any questions or suggestions, please leave a comment below and share your use case. I would love to hear from you.
