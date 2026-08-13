#dotnet run --project Ngan.Dict/Ngan.Dict.Test/proj/Ngan.Dict.Test
TestDll="Ngan.Dict/Ngan.Dict.Test/proj/Ngan.Dict.Test/bin/Debug/net10.0/Ngan.Dict.Test.dll"
TestDll=$(realpath -m $TestDll)
cd Ngan.Dict/Ngan.Dict.Frontend/proj/Ngan.Dict.Windows/bin/Debug/net10.0
dotnet $TestDll
