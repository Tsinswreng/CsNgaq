#dotnet run --project Ngaq.Test
dotnet publish Ngaq.Test/Ngaq.Test.csproj -c Release -r win-x64
TestDll="Ngaq.Test/bin/Release/net10.0/win-x64/publish/Ngaq.Test.exe"
TestDll=$(realpath -m $TestDll)
cd Ngaq.Frontend/proj/Ngaq.Windows/bin/Debug/net10.0
$TestDll
