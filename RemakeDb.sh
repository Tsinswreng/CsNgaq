rm Ngaq.Sqlite
rm -r Ngaq.Local/Migrations
dotnet ef migrations add Init --project ./Ngaq.Local
dotnet ef database update --project ./Ngaq.Local
