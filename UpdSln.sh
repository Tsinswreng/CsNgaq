rm Ngaq.sln
dotnet new sln -n Ngaq
dotnet sln add Ngaq.Core/Ngaq.Core.csproj
dotnet sln add Ngaq.Local/Ngaq.Local.csproj
dotnet sln add Ngaq.Test/Ngaq.Test.csproj
dotnet sln add Ngaq.Frontend/proj/**/*.csproj
dotnet sln add Ngaq.Server/proj/**/*.csproj

dotnet sln add Tsinswreng.CsCore/proj/**/*.csproj
dotnet sln add Tsinswreng.CsTools/proj/**/*.csproj
dotnet sln add Tsinswreng.CsDictMapper/proj/**/*.csproj
dotnet sln add Tsinswreng.CsSqlHelper/proj/**/*.csproj
dotnet sln add Tsinswreng.CsUlid/proj/**/*.csproj
dotnet sln add Tsinswreng.CsPage/proj/**/*.csproj
dotnet sln add Tsinswreng.CsCfg/proj/**/*.csproj
dotnet sln add Tsinswreng.Avalonia/proj/**/*.csproj
