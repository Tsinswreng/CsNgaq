# TODO 打包語言翻譯json文件
#CpAssets="$PWD/CpAssets.sh"
cd Ngaq.Frontend/proj/Ngaq.Windows
mkdir -p publish
mv publish publishOld
dotnet publish -c Release -r win-x64
rm -r publishOld

#sh $CpAssets
cd ../../../
sh ./CpAssets.sh
cd Ngaq.Frontend/proj/Ngaq.Windows

cd ./bin/Release/net9.0/win-x64
mkdir -p publishNoPdb
rm -r publishNoPdb
cp -r publish publishNoPdb
cd publishNoPdb
rm -r *.pdb
tar -czf ../Ngaq.Windows.tar.gz .
cd ..
mv Ngaq.Windows.tar.gz publishNoPdb/
