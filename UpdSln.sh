rm Ngaq.sln
dotnet new sln -n Ngaq
dotnet sln add Ngaq.Core/Ngaq.Core.csproj
dotnet sln add Ngaq.Local/Ngaq.Local.csproj
dotnet sln add Ngaq.Test/proj/**/*.csproj
dotnet sln add Ngaq.Frontend/proj/**/*.csproj
dotnet sln add Ngaq.Server/proj/**/*.csproj

dotnet sln add Tsinswreng.CsCore/proj/**/*.csproj
dotnet sln add Tsinswreng.CsTools/proj/**/*.csproj
dotnet sln add Tsinswreng.CsU128Id/proj/**/*.csproj
dotnet sln add Tsinswreng.CsErr/proj/**/*.csproj
dotnet sln add Tsinswreng.CsSrcGenTools/proj/**/*.csproj
dotnet sln add Tsinswreng.CsFactoryMkr/proj/**/*.csproj
dotnet sln add Tsinswreng.CsDictMapper/proj/**/*.csproj
dotnet sln add Tsinswreng.Srefl/proj/**/*.csproj
dotnet sln add Tsinswreng.CsIfaceGen/proj/**/*.csproj
dotnet sln add Tsinswreng.CsDecl/proj/**/*.csproj
dotnet sln add Tsinswreng.CsSql/proj/**/*.csproj
dotnet sln add Tsinswreng.CsPage/proj/**/*.csproj
dotnet sln add Tsinswreng.CsCfg/proj/**/*.csproj
dotnet sln add Tsinswreng.AvlnTools/proj/**/*.csproj
dotnet sln add Tsinswreng.CsYamlMd/proj/**/*.csproj
dotnet sln add Tsinswreng.CsTextWithBlob/proj/**/*.csproj
dotnet sln add Tsinswreng.CsTreeTest/proj/**/*.csproj
dotnet sln add Tsinswreng.CsTreeTest/proj/Samples/**/*.csproj
#dotnet sln add Tsinswreng.AvlnTools/Example/proj/**/*.csproj
dotnet sln add Tsinswreng.Avln.StrokeText/proj/**/*.csproj
#dotnet sln add Tsinswreng.Avln.StrokeText/Samples/StrokeText.Sample/**/*.csproj
dotnet sln add Thesis/proj/**/*.csproj
dotnet sln add Tsinswreng.OpenXmlTools/proj/**/*.csproj
