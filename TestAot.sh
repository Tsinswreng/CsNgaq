#dotnet run --project Ngan.Dict/Ngan.Dict.Test/proj/Ngan.Dict.Test
dotnet publish Ngan.Dict/Ngan.Dict.Test/proj/Ngan.Dict.Test/Ngan.Dict.Test.csproj -c Release -r win-x64
TestDll="Ngan.Dict/Ngan.Dict.Test/proj/Ngan.Dict.Test/bin/Release/net10.0/win-x64/publish/Ngan.Dict.Test.exe"
TestDll=$(realpath -m $TestDll)
cd Ngan.Dict/Ngan.Dict.Frontend/proj/Ngan.Dict.Windows/bin/Debug/net10.0
$TestDll
