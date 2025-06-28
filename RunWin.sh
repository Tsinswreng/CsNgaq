#注意 斷點調試旹蜮不珩下ʹ複製流程
DirRoot=$(pwd)
DirDebug="./Ngaq.Frontend/proj/Ngaq.Windows/bin/Debug/net9.0/"
DirWin="./Ngaq.Frontend/proj/Ngaq.Windows/"
mkdir -p $DirDebug
cp -r ./Assets/*  $DirDebug
#勿用此dotnet run --project ./Ngaq.Frontend/proj/Ngaq.Windows 先cd到目標目錄再運行、否則pwd與可執行程序不一致 影響相對路經解析
cd $DirWin
dotnet build --verbosity detailed
cd ./bin/Debug/net9.0/
./Ngaq.Windows.exe
