rm Ngaq.sln
dotnet new sln -n Ngaq
dotnet sln add Ngaq.Core/Ngaq.Core.csproj
dotnet sln add Ngaq.Local/Ngaq.Local.csproj
dotnet sln add Ngaq.Frontend/proj/**/*.csproj
dotnet sln add Ngaq.Server/proj/**/*.csproj
dotnet sln add Tsinswreng.CsCore/Tsinswreng.CsCore.csproj
dotnet sln add Tsinswreng.SrcGen/Tsinswreng.SrcGen.csproj
dotnet sln add Tsinswreng.SqlHelper/Tsinswreng.SqlHelper.csproj
