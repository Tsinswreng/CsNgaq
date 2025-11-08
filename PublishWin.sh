cd Ngaq.Frontend/proj/Ngaq.Windows
dotnet publish -c Release -r win-x64
cd ./bin/Release/net9.0/win-x64
cp -r publish publishNoPdb
cd publishNoPdb
rm -r *.pdb
tar -czf Ngaq.Windows.tar.gz .
