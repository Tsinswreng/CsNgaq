// pandoc README.typ -o README.md
= CsNgaq

An app helps you remember vocabularies

Tech Stack:
- Frontend: C\#, Avalonia
- Local Backend: C\#, Sqlite, #link("https://github.com/Tsinswreng/CsSqlHelper")[CsSqlHelper]
- Server Backend(in progress): C\#, Asp.net, EFCore, PostgreSql

Features:
- client AOT-compatible
- Support Windows, Linux, Android


= Try the app
Prerequisite:
- OS: Windows/Linux
- .NET9 installed

build and run:
+ clone the repo including its sub repo
+ run `./RunWin.sh`



= Word List Markup File

we use Word List Markup File to place the words and their meanings.
suppose when you are reading an article and there are some words you don't know. you can look up the words in online dictionaies and copy the words with its meaning into the word list markup file.
then import the word list file into the app. the app can parse it into word objects and store them in the local database.

== Format

*comments are not allowed*. In order to make convenience for introduction, here we use `#` as line comment mark

#let WordList = read("./WordList.typ")
#raw(WordList)

= Word Weight Algorithm

The app use a weight algorithm to calculate the priority of each word when learning. The main idea is to traverse the leaning records of each words and dynamicly adjust the weight value based on the learning records type (add, remember, forget) and its time.

the app has a built-in weight algorithm.

(in progress) you can also adjust the parameters of existing weight algorithm or define your own weight algorithm. to create custom algorithm, you need to implements the interfaces to make a executable file and specify the path in the app settings. we will call it through command line.

= Word Learning page

after start, short click the word card represents for remembering the word, long click for forgetting the word. click again is for undo. after each rotate of leaning, click save to save your new leaning records in the database and fresh the words weight

= Screenshots
#image("assets/2025-07-16-15-04-41.png")
#image("assets/2025-07-16-15-07-32.png")

= Server Backend (in progress)
- User Management
- word database remote sync



= 文件說明 2025-08-24T22:44:17.355+08:00_W34-7
- `_Note/`
- `AotTest.sh`
- `AotWin.sh` 腳本芝在項目根目錄AOT編譯Ngaq.Windows程序集
- `assets/` 存放圖片
- `ClearWin.sh` (已棄用)
- `CompileIfaceGenCli.sh` 編譯源生成器命令行工具並複製到 ./Tsinswreng.CsIfaceGen.Cli.exe
- `Compose.sh` docker厎 自己看
- `CpAssets.sh`
- `ExternalRsrc/` 㕥存外部資源、即發佈旹與exe同目錄ⁿ不被打包進exe者
- `GitSubMod.sh` 初始化git子模塊
- `Ngaq.Core/` 平臺無關Ngaq共用庫
- `Ngaq.Frontend/` Avalonia項目
- `Ngaq.Local/` 本地後端(與前端一起編譯)
- `Ngaq.Server/` 遠端後端(WebApi)
- `Ngaq.sln` 自動生成厎 除供vscode C\# LSP外 無用
- `Ngaq.Test/` 測試項目
- `README.md` pandoc從README.typ轉換來
- `README.typ` 讀余
- `RemakeDb.sh` (已棄用)Ngaq.Local項目 efcore緟生成遷移
- `RunBrowser.sh` dotnet run Avalonia web項目
- `RunWin.sh` 複製外部資產 debug模式編譯Nagq.Windows項目並運行、pwd同于exeʃ在ʹ目錄
- `Test.sh` dotnet run 運行Ngaq.Test入口
- `Todo/` 待做之錄
- `Tsinswreng.AvlnTools/` Avalonia工具庫
- `Tsinswreng.CsCfg/` 配置系統庫
- `Tsinswreng.CsCore/` C\# 共享庫
- `Tsinswreng.CsDictMapper/` 詞典映射源生成器庫
- `Tsinswreng.CsIfaceGen/` 標記接口源生成器庫
- `Tsinswreng.CsIfaceGen.Cli.exe` Tsinswreng.CsIfaceGen/proj/Tsinswreng.CsIfaceGen.Cli/ ᙆ得ʹ命令行工具、用于生成代碼並寫入項目文件、git提交旹作潙源碼ʹ一部
- `Tsinswreng.CsPage/` 分頁模型庫
- `Tsinswreng.CsSqlHelper/` 輕量ORM庫
- `Tsinswreng.CsSrcGenTools/` 工具庫潙源生成器項目
- `Tsinswreng.CsTools/` C\#工具庫
- `Tsinswreng.CsTypeAlias/` 類型別名
- `Tsinswreng.CsUlid/` ULID庫
- `UpdSln.sh`	清除根目錄ʹ .sln並根據所有`.csproj`緟生成
- `WebSrv.sh` 複製外部資源並構建遠程後端
- `WordList.typ` 單詞表示例
