WindowsDirDebug="./Ngaq.Frontend/proj/Ngaq.Windows/bin/Debug/net9.0/"
mkdir -p $WindowsDirDebug
cp -r ./ExternalRsrc/*  $WindowsDirDebug

WebDirDebug=./Ngaq.Server/proj/Ngaq.Web/bin/Debug/net9.0/
mkdir -p $WebDirDebug
cp -r ./Ngaq.Server/ExternalRsrc/*  $WebDirDebug

