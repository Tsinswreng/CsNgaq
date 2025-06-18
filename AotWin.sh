cd ./Ngaq.Frontend/proj/Ngaq.Windows
#dotnet publish -c Release -r win-x64
dotnet publish -c Release -r win-x64 --self-contained true
./bin/Release/net9.0/win-x64/publish/Ngaq.Windows.exe
