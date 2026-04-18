rm Ngaq.Sqlite
rm -r Ngaq.Backend/Migrations
dotnet ef migrations add Init --project ./Ngaq.Backend
dotnet ef database update --project ./Ngaq.Backend
