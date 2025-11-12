WindowsDirDebug="./Ngaq.Frontend/proj/Ngaq.Windows/bin/Debug/net10.0/"
mkdir -p $WindowsDirDebug
cp -r ./ExternalRsrc/*  $WindowsDirDebug

WebDirDebug=./Ngaq.Server/proj/Ngaq.Web/bin/Debug/net10.0/
mkdir -p $WebDirDebug
cp -r ./Ngaq.Server/ExternalRsrc/*  $WebDirDebug

DirWinPublish=./Ngaq.Frontend/proj/Ngaq.Windows/bin/Release/net10.0/win-x64/publish
mkdir -p $DirWinPublish
cp -r ./ExternalRsrc/*  $DirWinPublish

DirAndroidAssets=./Ngaq.Frontend/proj/Ngaq.Android/Assets
mkdir -p $DirAndroidAssets
cp -r ./ExternalRsrc/*  $DirAndroidAssets
