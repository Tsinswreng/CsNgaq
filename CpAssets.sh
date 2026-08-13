WindowsDirDebug="./Ngan.Dict/Ngan.Dict.Frontend/proj/Ngan.Dict.Windows/bin/Debug/net10.0/"
mkdir -p $WindowsDirDebug
cp -r ./ExternalRsrc/*  $WindowsDirDebug
cp -r ./ExternalRsrc.__Private/*  $WindowsDirDebug

DirLinuxDebug="./Ngan.Dict/Ngan.Dict.Frontend/proj/Ngan.Dict.Linux/bin/Debug/net10.0/"
mkdir -p $DirLinuxDebug
cp -r ./ExternalRsrc/*  $DirLinuxDebug
cp -r ./ExternalRsrc.__Private/*  $DirLinuxDebug

DirLinuxPublish="./Ngan.Dict/Ngan.Dict.Frontend/proj/Ngan.Dict.Linux/bin/Release/net10.0//linux-x64/publish/"
mkdir -p $DirLinuxPublish
cp -r ./ExternalRsrc/*  $DirLinuxPublish
cp -r ./ExternalRsrc.__Private/*  $DirLinuxPublish


DirWinPublish=./Ngan.Dict/Ngan.Dict.Frontend/proj/Ngan.Dict.Windows/bin/Release/net10.0/win-x64/publish
mkdir -p $DirWinPublish
cp -r ./ExternalRsrc/*  $DirWinPublish

DirAndroidAssets=./Ngan.Dict/Ngan.Dict.Frontend/proj/Ngan.Dict.Android/Assets
mkdir -p $DirAndroidAssets
cp -r ./ExternalRsrc/*  $DirAndroidAssets


WebDirDebug=./Ngan.Dict/Ngan.Dict.Server/proj/Ngan.Dict.Server.Http/bin/Debug/net10.0/
mkdir -p $WebDirDebug
cp -r ./Ngan.Dict/Ngan.Dict.Server/ExternalRsrc/*  $WebDirDebug
