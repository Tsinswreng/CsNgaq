#dotnet run --project Ngaq.Test -c Release -r win-x64
cd ./Ngaq.Test
dotnet publish -c Release -r win-x64
./bin/Release/net9.0/win-x64/publish/Ngaq.Test.exe
