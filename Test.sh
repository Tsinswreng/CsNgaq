#dotnet run --project Ngaq.Test
TestDll="Ngaq.Test/bin/Debug/net10.0/Ngaq.Test.dll"
TestDll=$(realpath -m $TestDll)
cd Ngaq.Frontend/proj/Ngaq.Windows/bin/Debug/net10.0
dotnet $TestDll
