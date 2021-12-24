# Noteworthy Wrapper

Current version: 1.0

Noteworthy Wrapper is a custom-made build tool for Noteworthy II WoW addon. It is used for the addon development, doing
tasks such as preparing packages for distribution, installing and uninstalling the addon locally etc.

Wrapper is written in Java and uses the _[picocli](https://picocli.info/)_ library for creating CLI commands. Everything
is packed in a fat jar and all commands are invoked by using the helper scripts `nww.bat` or `nww.sh`.

# Usage

### Packaging

Packaging is done with `nww.bat pack` command:

```shell
> nww.bat pack -h
Usage: pack [-hV] [-b=<baseDirectory>] [-pv=<packageVersion>]
            [-rd=<resultDirectory>]
Packages the Noteworthy II source to a zip file. Package version can be
provided to be included in the name, otherwise current timestamp is appended.
  -b, --baseDir=<baseDirectory>
                  Noteworthy II source location. Default is the local directory.
  -h, --help      Show this help message and exit.
      -pv, --packageVersion=<packageVersion>
                  Package version that will be included in the name.
      -rd, --resultDir=<resultDirectory>
                  Location of the package output. Default is the local
                    directory.
  -V, --version   Print version information and exit.
```

Example usage:

```shell
> nww.bat pack
Creating: ./NoteworthyII_14052021144600.zip
Zipping: .\src\lua\GhostLib.lua
Zipping: .\src\lua\NoteworthyBroker.lua
Zipping: .\src\lua\NoteworthyMain.lua
Zipping: .\src\lua\NoteworthySystem.lua
Zipping: .\src\xml\GhostLib.xml
Zipping: .\src\xml\NoteworthyButton.xml
Zipping: .\src\xml\NoteworthyOptions.xml
Zipping: .\src\xml\NoteworthyTemplates.xml
Zipping: .\src\xml\NoteworthyWindows.xml
Zipping: .\lib\CallbackHandler-1.0.lua
Zipping: .\lib\LibDataBroker-1.1.lua
Zipping: .\lib\LibDBIcon-1.0.lua
Zipping: .\lib\LibStub.lua
Zipping: .\NoteworthyII.toc
Zipping: .\README.md
Zipping: .\LICENSE.txt
./NoteworthyII_14052021144600.zip created.
```

### Installation

Installation is done with `nww.bat install` command:

```shell
> nww.bat install -h
Usage: install [-hV] [-b=<baseDirectory>] [-i=<installationDirectory>]
Installs the given Noteworthy II source to the WoW installation directory. The
directory can be passed as a parameter. If not, it is read from 'WOWIL'
environment variable.
  -b, --baseDir=<baseDirectory>
                  Noteworthy II source location. Default is the local directory.
  -h, --help      Show this help message and exit.
  -i, --installationDir=<installationDirectory>
                  WoW game installation directory. Default is the value of
                    'WOWIL' environment variable if present, otherwise local
                    directory.
  -V, --version   Print version information and exit.
```

Example usage:

```shell
>nww.bat install
Installing from: . to: C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII
Installing: .\src\lua\GhostLib.lua to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\GhostLib.lua
Installing: .\src\lua\NoteworthyBroker.lua to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\NoteworthyBroker.lua
Installing: .\src\lua\NoteworthyMain.lua to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\NoteworthyMain.lua
Installing: .\src\lua\NoteworthySystem.lua to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\NoteworthySystem.lua
Installing: .\src\xml\GhostLib.xml to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\GhostLib.xml
Installing: .\src\xml\NoteworthyButton.xml to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\NoteworthyButton.xml
Installing: .\src\xml\NoteworthyOptions.xml to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\NoteworthyOptions.xml
Installing: .\src\xml\NoteworthyTemplates.xml to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\NoteworthyTemplates.xml
Installing: .\src\xml\NoteworthyWindows.xml to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\NoteworthyWindows.xml
Installing: .\lib\CallbackHandler-1.0.lua to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\lib\CallbackHandler-1.0.lua
Installing: .\lib\LibDataBroker-1.1.lua to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\lib\LibDataBroker-1.1.lua
Installing: .\lib\LibDBIcon-1.0.lua to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\lib\LibDBIcon-1.0.lua
Installing: .\lib\LibStub.lua to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\lib\LibStub.lua
Installing: .\NoteworthyII.toc to C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII\NoteworthyII.toc
Noteworthy II installed to: C:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII
```

### Hashing

Hashing is done with `nww.bat hash` command:

```shell
> nww.bat hash -h
Usage: hash [-hV] [-a=<algorithm>] <packageToHash>
Creates a hash value for the given package file. Can use MD5, SHA-1, SHA-256,
SHA-384 and SHA-512.
      <packageToHash>   Package to hash.
  -a, --algorithm=<algorithm>
                        Algorithm to use for hashing. Can be MD5, SHA-1,
                          SHA-256, SHA-384 and SHA-512. Default is MD5.
  -h, --help            Show this help message and exit.
  -V, --version         Print version information and exit.
```

Example usage:

```shell
> nww.bat hash NoteworthyII_14052021150141.zip
cd79b5007865974ec9d2528e52294aae
```

### Uninstalling

Uninstalling is done with `nww.bat uninstall` command:

```shell
> nww.bat uninstall -h
Usage: uninstall [-hV] [-i=<installationDirectory>]
Uninstalls Noteworthy II from WoW addons location.
  -h, --help      Show this help message and exit.
  -i, --installationDir=<installationDirectory>
                  WoW game installation directory. Default is the value of
                    'WOWIL' environment variable if present, otherwise local
                    directory.
  -V, --version   Print version information and exit.
```

Example usage:

```shell
> nww.bat uninstall
Uninstalling Noteworthy II from: D:\Games\World of Warcraft\_retail_\Interface\AddOns\NoteworthyII
Noteworthy II uninstalled.
```

### Changelog Delta

This command can extract entries from the changelog for the specified version
or version range.  

```shell
> nww.bat changelog -h
Usage: changelog [-hV] [-c=<changelogLocation>] -vf=<versionFrom>
                 [-vt=<versionTo>]
Extracts info from the Change log for the required version range.
  -c, --changelogLocation=<changelogLocation>
                  The location of the change log file. Default is the file from
                    the repository.
  -h, --help      Show this help message and exit.
  -V, --version   Print version information and exit.
      -vf, --versionFrom=<versionFrom>
                  Starting version / heading.
      -vt, --versionTo=<versionTo>
                  End version / heading.
```

Example usage (with one version):

```shell
> nww.bat changelog -vf 2.3.0
## V2.3.0
- General
  - Introduce the undo feature for each tab
- UI
  - Introduce 'Undo' button in the top right corner of the Noteworthy window
```

With version range:

```shell
> nww.bat changelog -vf 2.3.0 -vt 2.2.1
## V2.3.0
- General
  - Introduce the undo feature for each tab
- UI
  - Introduce 'Undo' button in the top right corner of the Noteworthy window

## V2.2.1
- General
  - Update interface version
```

### Upload to CurseForge

This command is used to upload a release to CurseForge (in the project files section).
The release package should be present (see _Packaging_) before running the command.

```shell
> nww.bat upload -h
Usage: upload [-hV] -gv=<gameVersion> -p=<pathToPackage> -rv=<releaseVersion> 
Uploads a Noteworthy II package and its associated metadata to CurseForge as a
release.
      -gv, --gameVersion=<gameVersion>
                  Supported WoW version by the package being uploaded.        
  -h, --help      Show this help message and exit.
  -p, --pathToPackage=<pathToPackage>
                  Path to the release package.
      -rv, --releaseVersion=<releaseVersion>
                  Release version of the Noteworthy II package.
  -V, --version   Print version information and exit. 
```

Usage:

```shell
> nww.bat upload -p .\NoteworthyII_2.3.2-classic-era.zip -rv 2.3.2 -gv 1.14.0
Requesting WoW game versions with release version '1.14.0'.
Found game version ID: '8668'.
Attempting to upload release to CurseForge... 
Release uploaded to CurseForge, file ID: 58642
```