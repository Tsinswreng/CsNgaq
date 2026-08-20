-Sesn[
	-T[2026_0815_221607][
		看skill和記憶。
		然後看 `E:\_code\Ngan\_Note\Cssh\2026_0813_224620\Init.typ`
		
		你這做得也太屎了吧 怎麼連個cd都要弄這麼複雜?
		能不能給我好好弄
	][

	]
	
	
	-T[2026_0815_223431][

		`E:\_code\Ngan\Tsinswreng.Cssh\Samples\PublishWin.csx`
		我幫你弄到這裏來了。改這下面的。
		````
		File: e:\_code\Ngan\Tsinswreng.Cssh\Samples\PublishWin.csx
8: var ProjectDir = Path.Combine(Root, "Ngan.Dict", "Ngan.Dict.Frontend", "proj", "Ngan.Dict.Windows");

		````
		不覺得很麻煩嗎? 直接用正斜槓不就完了嗎? 搞這種
	][
		
		新增：Cssh 的所有路徑參數接受正斜槓。腳本直接寫 #raw("src/app")、
		#raw("bin/Release/net10.0")；不需要爲一般腳本路徑調用 #raw("Path.Combine")。

		新增：#raw("X(\"dotnet publish -c Release\")") 爲腳本的主入口。
		它只解析程式名和參數，不啓動 Bash、PowerShell 或 cmd；管道、重定向與
		#raw("&&") 等 shell 語法不在這個重載的範圍內。

		新增：#raw("ScriptDir()") 取得 csx 文件所在目錄，#raw("Args()") 取得傳給 csx 的參數，
		#raw("Ls()") 以 Bash 風格惰性列出目錄中的子項。這三項由同步技能樣本直接需要。
		#raw("Ls()") 與 #raw("Find()") 均回傳
		#raw("FileSystemEntry(Path, Name, IsFile, IsDir, IsLink)")；以 #raw("IsFile")、
		#raw("IsDir")、#raw("IsLink") 區分類型，避免腳本從裸路徑字串猜測類型或自行拆出名稱。
		#raw("Find(\"src/**/*.csproj\")") 直接接收 Bash 風格 glob 路徑，不提供
		#raw("Under")、#raw("Recursive") 之類的 .NET 式搜尋參數。

		新增：#raw("Q(Value)") 將動態路徑或文本編碼爲 #raw("X") 命令中的單一參數。
		例如 #raw("X($\"dotnet sln add {Q(Project.Path)}\")")；動態值不應直接拼入命令字串。

		新增：#raw("Echo(Text)") 輸出一行文本，作爲 csx 中 #raw("Console.WriteLine") 的 Bash 風格替代。

		修改：高頻命令調用統一爲 #raw("X(Command, Cwd: null)") 與
		#raw("TryX(Command, Cwd: null)")。樣本不構造 #raw("CommandSpec")、不傳參數陣列；
		#raw("CommandSpec") 只保留給需要環境變量覆蓋或捕獲輸出的低層場景。

		約束：Samples 下的 csx 不使用項目內的 #raw("str") 等類型別名，
		因 dotnet-script 只引用 Cssh 程序集時不會自動引用 #raw("TypeAlias.cs")。

		修改：#raw("X") 現在只建立惰性 #raw("Command") DTO，不立即執行。
		#raw("Command.Result") 爲 #raw("CommandResult(Stdout, Stderr)")，兩個字段均是
		可讀 Stream；首次異步消費其中任一流或等待 #raw("Command.Done") 時才啓動命令。
		#raw("Input") 僅是 #raw("X") 的外部輸入，不屬於命令結果。
		#raw("Write(Target, Source)") 及所有文件系統操作均爲非同步；
		#raw("Find")、#raw("Ls") 改爲 #raw("IAsyncEnumerable")。
		Samples/Cssh.csx 爲完整 API 樣本，統一展示環境、文件系統、列舉、命令、
		stdin/stdout/stderr、覆寫、追加、丟棄、合併與管道。
	]
	
	-T[2026_0815_224644][
		`E:\_code\Ngan\PublishWin.sh`
		`E:\_code\Ngan\UpdSln.sh`
		`E:\_code\Ngan\SyncSkills.sh`
		這三個 都弄一份csx的版本到Samples/下
		
	][
		
	]
	
	-T[2026_0815_231526][
去調研一下有沒有現成的庫
	][
````md
有，但沒有一個能整體替代 Cssh。

| 範圍 | 現成庫 | 結論 |
|---|---|---|
| 外部命令 | [CliWrap](https://github.com/Tyrrrz/CliWrap) 3.10.4 | 最適合作為 Cssh 的底層。跨 Windows/Linux/macOS、async、取消、管線、輸出捕獲、非零退出預設報錯；MIT。其倉庫已有「改用 `LibraryImport` 以正確支援 AOT」的已合併修正。 |
| 外部命令 | [MedallionShell](https://github.com/madelson/MedallionShell) 1.6.2 | 功能也完整、MIT，但版本與維護活躍度相較 CliWrap 偏舊；不推薦新選。 |
| Glob | [Glob](https://github.com/kthompson/glob) | 支援 `/`、`*`、`?`、`**`、`{a,b}`，並有檔案系統枚舉；MIT。穩定版是 1.1.9，最新 2.1 仍 alpha。 |
| Glob | [DotNet.Glob](https://github.com/dazinator/DotNet.Glob) | 同樣支援 `**`，MIT；穩定版 3.1.3。它偏「pattern matcher」，檔案系統枚舉仍要 Cssh 自己做。 |
| 檔案系統抽象 | [Zio](https://github.com/xoofx/zio) 0.24.0 | 跨平台統一路徑、檔案/目錄條目、虛擬檔案系統、記憶體檔案系統；BSD-2-Clause。功能遠超 Cssh 所需，作為簡單腳本工具的依賴太重。 |
| `.csx` 執行器 | [dotnet-script](https://github.com/dotnet-script/dotnet-script) 2.0.1 | 就是既定選擇；提供全域 `Args`，可在腳本內用 `#r "nuget:..."`。 |

建議：

- Cssh 繼續保留，因為你的 `X / Cd / Echo / Ls / Find / Rm / Cp / Mv` 是「Bash 風格腳本表層」，沒有現成庫提供。
- 底層採用 `CliWrap` 處理 `X / TryX`，不要自行重造 `Process` 的取消、輸出管線、死鎖處理。
- `Find` 的 glob 若要外部依賴，選 `Glob`；若不想引入 alpha，鎖定其 1.1.9 穩定版。檔案列舉與 `FileSystemEntry` 仍由 Cssh 薄封裝。
- 不建議引入 Zio，除非後續需要記憶體、ZIP、掛載等多種檔案系統。

NativeAOT 的限制仍要以實際發布驗證；官方建議在庫專案設定 `IsAotCompatible=true` 並啟用相依套件驗證。這次只調研，沒有修改代碼。
````
	]
	
	-T[2026_0815_232121][
		bash的輸入輸出  管道  重定向 這些在你這對應甚麼? 以及你這個全是阻塞的嗎
	][
````md
目前這套宣告沒有對應：`X` 只能跑單一命令；管道、重定向都還沒設計。簡單 `X(...)` 目前也是阻塞的。這是設計缺口。

我建議 Cssh 的腳本層直接吃一個「受限 Bash 命令列」：

```csharp
X($"dotnet build > {Q("build.log")} 2> {Q("build.err")}");
X($"git log | grep {Q("release")}");
X($"tool < {Q("input.txt")} >> {Q("output.txt")}");
X("tool 2>&1");
```

對應如下：

- `|`：標準輸出接下一命令的標準輸入；管線內進程並行執行。
- `>` / `>>`：覆寫／附加標準輸出至檔案。
- `<`：檔案作標準輸入。
- `2>` / `2>>`：覆寫／附加標準錯誤至檔案。
- `2>&1`：標準錯誤合併至標準輸出。
- `Q(Value)`：把 C# 動態值安全地編碼成單一命令參數。

不該直接呼叫 Bash、PowerShell 或 cmd；應由 Cssh 自己跨平台解析這個有限子集。暫不支援 `&&`、`;`、變數展開、`$()` 等 shell 語法，這些用 C# 的 `if`、變數與函數本身完成。

阻塞模型應同時提供：

```csharp
X("dotnet build");              // 同步，符合 Bash 腳本逐行語義
await X("dotnet build", Ct);    // 非同步、可取消
```

管線即使外層採同步 `X`，內部也必須並行泵送資料，否則會死鎖。

這代表要正式把 `X` 從「命令列分詞」升級為「有限 Bash I/O 語法解析器」。你確認這個範圍後，我再改宣告；不會再先做零碎補洞。
````
	]
	
	
	-T[2026_0815_232758][
````
X($"dotnet build > {Q("build.log")} 2> {Q("build.err")}");
X($"git log | grep {Q("release")}");
X($"tool < {Q("input.txt")} >> {Q("output.txt")}");
X("tool 2>&1");
````
別光許願！那你說你這得怎麼實現? 相當于自己又要寫一個解析器? 從他字符串做語法分析? 那不是亂搞嗎?

所有的 能異步的就異步 全部異步優先！
	][
````md
你說得對，不能把 Bash 字串塞進 `X` 再自己解析。那條路應該廢棄。

現有 `X(string Command)`、`Q()` 都不該保留。正確做法是：命令、參數、管道、重定向在 C# 層已是結構化物件，執行時直接逐參數傳給 `Process`／CliWrap，完全不做字串語法分析、不啟動 Bash。

建議的腳本表層：

```csharp
await X("dotnet", "build", Out("build.log"), Err("build.err"));

await (X("git", "log") | X("grep", "release"));

await X(
	"tool",
	In("input.txt"),
	AppendOut("output.txt"));

await X("tool", MergeErr());
```

定義：

- `X(...)`：建立一個尚未執行的命令；`await X(...)` 才啟動並等待。
- 字串參數：每個都是獨立參數，不需 `Q()`，含空格也安全。
- `Out(path)` / `AppendOut(path)`：`>` / `>>`
- `Err(path)` / `AppendErr(path)`：`2>` / `2>>`
- `In(path)`：`<`
- `MergeErr()`：`2>&1`
- `|`：C# 運算子組成管線。沒有解析器，左右都是已結構化的命令。
- 管線中所有子進程同時非同步啟動；stdout→stdin 用非同步串流轉送，並同時等待轉送與所有進程結束，避免 pipe buffer 滿造成死鎖。

底層實作：

- 命令執行採 `CliWrap`；它已處理跨平台 Process、個別參數、取消、stdout/stderr 及管線。
- Cssh 只負責把 `X / Out / Err / In / MergeErr / |` 轉成 CliWrap 的 command/pipes 設定。
- 不解析 Bash、PowerShell、cmd 語法，因此 `&&`、`$()`、變數展開不支援；C# 的 `if`、函數、變數就是等價替代。
- `CommandResult` 保留退出碼、時間、必要時捕獲輸出；`X` 非零退出丟例外，`TryX` 不丟。

異步優先應重做為：

- `X` / `TryX`：回傳可 await 的非同步命令。
- `Mkdir`、`Rm`、`Cp`、`Mv`、`Read`、`Write`、`Echo`：`Task`／`ValueTask`。
- `Ls`、`Find`：`IAsyncEnumerable<FileSystemEntry>`，用 `await foreach`。
- `Pwd`、`Args`、`ScriptDir` 這種純記憶體／程序狀態讀取可保持同步。

這會讓 Samples 改成全程 `await`，例如：

```csharp
await Rm("publishOld", Force: true);
await X("dotnet", "publish", "-c", "Release");
await foreach (var Pdb in Find("publishNoPdb/**/*.pdb"))
	await Rm(Pdb.Path);
```

我理解的本次需求確認是：刪除目前字串命令解析設計，改為「型別化命令圖 + CliWrap 底層 + 全面 async-first」，並以以上 API 取代現有宣告與 Samples。你確認後我才重寫 decl。
````
	]
	
	-T[2026_0815_233417][
		你這更醜了 醜爆了！
		我只要你具有應有的功能
		不是非得抄他的寫法
	][
````md
對。剛才那套 `Out(...) / Err(...) / In(...) / MergeErr()` 是把 Bash 記號硬翻成 C#，又醜又沒必要。

真正的約束是：

- 要 `X("git log | grep release")` 這種完整字串，還要管道／重定向，必然要有 shell 或自己解析語法。
- 不要 shell、不要自己寫解析器，就不能把多個命令與 I/O 關係塞進一條字串。
- 但功能可以用正常 C# API 表達，不必模仿 Bash 符號。

我建議表層改成自然的 fluent API：

```csharp
await X("git log")
	.Pipe("grep release");

await X("tool")
	.Input("input.txt")
	.Output("output.txt", append: true)
	.Error("error.txt");

await X("tool")
	.MergeError();
```

`X(...)` 只表示一條命令；`.Pipe(...)`、`.Input(...)`、`.Output(...)`、`.Error(...)`、`.MergeError()` 表達 I/O 關係。底層用 CliWrap 的結構化 process/pipe API，沒有自建 shell 語法分析器。

所有可 I/O 的操作改為非同步：

```csharp
await X("dotnet publish -c Release");
await Rm("publishOld", Force: true);
await Cp("publish", "publishNoPdb");

await foreach (var Item in Find("src/**/*.csproj")) {
	// ...
}
```

純讀取程序狀態的 `Pwd()`、`Args()`、`ScriptDir()` 可保持同步。

但還有一個無法同時滿足的點要你裁定：`X("dotnet publish -c Release")` 這種「完整命令字串」本身仍需要至少拆出 executable 與 arguments。若完全拒絕任何字串解析，必須改為：

```csharp
await X("dotnet", "publish -c Release");
```

這仍是兩個普通字串，不用 `new`、陣列或手動引用；管道同理：

```csharp
await X("git", "log").Pipe("grep", "release");
```

請確認要哪一個：

1. 保留完整命令字串 `X("dotnet publish ...")`，接受最小的命令列分詞。
2. 完全不做字串分詞，改為 `X("dotnet", "publish ...")`。
````
	]
	
	-T[2026_0815_234019][
		你強制可執行文件和參數分開那寫腳本的一方寫起來就複雜了啊
		之前都說過不要這樣了
		你自己解析 按第一個空白字符分隔出 可執行文件和參數不就行了?
		這樣實現也簡單。
		另外你輸出輸出重定向這套API 功能完備嗎?
	][
````md
對，`X` 就按你說的做：

```csharp
X("dotnet publish -c Release")
```

Cssh 只找第一個空白字元：

- 前段：可執行檔 `dotnet`
- 後段：原樣作為 arguments 字串 `publish -c Release`

後段不由 Cssh 再分詞、不解析引號、不解析 `|`／`>`；直接交給底層 `ProcessStartInfo.Arguments`／CliWrap。這不是重寫 shell，實作很簡單。

我前面那套 I/O API 不算完備。完整的需求至少應有：

| 標準流 | 必要去向 |
|---|---|
| stdin | 繼承終端、檔案、文字/Stream、另一命令的 stdout |
| stdout | 繼承終端、覆寫檔案、附加檔案、捕獲、丟棄、下一命令 stdin |
| stderr | 繼承終端、覆寫檔案、附加檔案、捕獲、丟棄、合併到 stdout |

而且全部應非同步：

- 命令啟動、等待退出、讀寫檔案、stdout/stderr 串流轉送都走 async。
- 管線兩端必須同時啟動，並以 async stream copy 轉送；任一端失敗或取消時，要終止其餘命令，避免卡住。
- `await` 一條命令等待完成；不 `await` 就可先組合或並行啟動。
- `X` 預設終端 I/O 直通；需要取得文字時顯式要求 capture，避免無限制吃記憶體。

唯一要先定的邊界是：照「第一個空白切 executable」規則，`C:/Program Files/tool.exe arg` 無法自動識別路徑中的空格。我的建議是只為這個罕見情況保留第二個 overload：

```csharp
X("C:/Program Files/tool.exe", "arg")
```

一般腳本仍全部寫一個字串。你確認這個例外可以後，我再重新設計完整的 async I/O／管線 decl。
````
	]
	
	-T[2026_0815_234549][
		不對啊 你這arguments是能多個的嗎? 按我的分法就只有一個參數了啊?
		你這都不提醒我? 我說甚麼就是甚麼?? 只會附和我?
	][
````md
你說得對，我剛才應該當場指出來，不該順著「第一個空白切」就說可行。

先釐清：`X("dotnet publish -c Release")` 內部確實可只切一次：

```text
可執行檔：dotnet
原始參數字串：publish -c Release
```

第二段雖然在 C# 裡是一個 `string`，但交給 `ProcessStartInfo.Arguments` 後，目標程式實際收到的仍是多個參數：

```text
["publish", "-c", "Release"]
```

所以「內部只有一個 arguments 字串」不等於 `dotnet` 只收到一個參數。

但問題是：這讓參數分詞與引號規則交給平台／目標程式處理。它能方便地涵蓋普通腳本，卻不能保證跨平台的一致 quoting。例如：

```csharp
X("tool \"a b\"")
```

以及「可執行檔路徑本身含空格」：

```csharp
X("C:/Program Files/tool.exe arg")
```

後者在「第一個空白切分」規則下必然錯，無法靠後續 arguments 處理補救。這是我應該先提出的衝突：

| 目標 | 後果 |
|---|---|
| 普通建構腳本寫得短 | `X("dotnet publish ...")`，只切第一個空白，足夠且簡單 |
| 所有合法路徑／引號跨平台正確 | 不能只按第一個空白切；需額外語法或第二種 API |

我建議明確定成兩層，而不是假裝一招全解：

```csharp
await X("dotnet publish -c Release"); // 主要腳本寫法：一個字串，第一空白切分

await XExe("C:/Program Files/tool.exe", "arg"); // 只有 executable 含空白時
```

`X` 的後半段保留為原始 arguments command line；`XExe` 才走 `ArgumentList`，確保精確參數。這不是附和，而是把「腳本簡潔」和「極端輸入正確」各自有明確邊界。

你若不接受第二個例外 API，就必須接受「可執行檔不可含空白」這個限制；兩者不可同時成立。
````
	]
	
	-T[2026_0815_234756][
		那你自己弄一個 Stdin, Stdout, Stderr 作C\#對象,
		輸出輸出 就拿中間變量存Stream 不就行了?
		這樣不就都有了?
		
	][
````md
對，這才是正確方向：不解析 `|`、`>`，而是把每個進程的三條標準流做成 C# 物件，透過 `Stream` 連接。

但不能只裸露 `Stream`；必須由 Cssh 的 `Stdin / Stdout / Stderr` 物件管理「何時開始、非同步轉送、EOF 後關閉下游 stdin、取消時終止進程」，否則管線很容易卡死。

設計應是：

```csharp
var Cmd = X("dotnet build"); // 只切第一個空白：dotnet + 原始 arguments 字串

await using var Out = File.Create("build.log");
await using var Err = File.Create("build.err");

Cmd.Stdout.To(Out);
Cmd.Stderr.To(Err);

await Cmd.Start(Ct);
```

管線：

```csharp
var Git = X("git log");
var Grep = X("grep release");

var Pipe = Git.Stdout.PipeTo(Grep.Stdin, Ct);

var GrepTask = Grep.Start(Ct);
var GitTask = Git.Start(Ct);

await Task.WhenAll(GitTask, Pipe, GrepTask);
```

`PipeTo` 內部是 `CopyToAsync`，來源 EOF 後必須關閉 `Grep.Stdin`，否則 `grep` 會永遠等輸入。三個 task 都是非同步；不能先 `await Git.Start()` 再啟動 `grep`。

基本 I/O 能力完整對應如下：

| Bash | Cssh |
|---|---|
| `< input.txt` | `Cmd.Stdin.From(InputStream)` |
| `> output.txt` | `Cmd.Stdout.To(OutputStream)` |
| `>> output.txt` | 開啟 append 模式的 `OutputStream` 後 `.To(...)` |
| `2> error.txt` | `Cmd.Stderr.To(ErrorStream)` |
| `2>&1` | `Cmd.Stderr.MergeTo(Cmd.Stdout)` |
| `a \| b` | `A.Stdout.PipeTo(B.Stdin, Ct)` |
| 丟棄 | `.To(Stream.Null)` |
| 捕獲 | `.To(MemoryStream)` |
| 直通終端 | `.To(Console.OpenStandardOutput())`／`Console.OpenStandardError()` |

有一個實作約束必須明確：`Stdout` 和 `Stderr` 同時寫同一個目標（`2>&1`）時，不能各自直接 `CopyToAsync` 同一個 `FileStream`；Cssh 必須用一個內部串列化 sink 統一寫入，避免競爭、損壞或錯誤關閉目標流。

因此應改成：

- `X(...)` 回傳尚未啟動的 `Command` 物件。
- `Command.Stdin`、`.Stdout`、`.Stderr` 是 Cssh 物件，不是裸 `Stream`。
- 它們接受或提供 `Stream`，並封裝生命週期。
- `Start(CT)`、所有檔案操作、所有 stream copy 都是 async。
- `Ls`／`Find` 改為 `IAsyncEnumerable<FileSystemEntry>`。
- `Pwd`、`Args`、`ScriptDir` 這種純取值保留同步。

這樣具備應有功能，也沒有自建 shell 解析器。確認後我會一次重寫命令 I/O 的 decl 與 Samples，不再零碎補 API。
````
	]
	
	-T[2026_0815_235216][
		我tm不是這個意思！你tm又搞這麼麻煩！
		我說你弄三個static 成員
		一個Stdin
		一個Stdout
		一個Stderr
		他們都相當於文件。
		所有輸入輸出都用Stream類。
		````cs
		var a = await X("git status");
		Write(Stdout, a.Result)//a.Result 是 Stream
		````
		這樣行不行?
		不要我說甚麼就是甚麼 你自己評估 不行的你要說！
		不要又像上次一樣
		
		
	][
````md
這個思路可以作為「捕獲完成後再轉送」的簡便 API，但不能單靠它覆蓋管道與即時輸出。

你的例子可定義為：

```cs
var A = await X("git status");
await Write(Stdout, A.Result);
```

其中：

- `Stdin` / `Stdout` / `Stderr`：三個靜態、可讀寫的終端 `Stream`。
- `A.Result`：命令 stdout 的可讀 `Stream`。
- `Write(Target, Source)`：非同步把 `Source` 複製至 `Target`。

這能做：

- 捕獲 stdout 後輸出到終端／檔案／記憶體 Stream。
- 將檔案 Stream 寫到 `Stdin`。
- 把結果寫到任何 Stream。

但它不能單獨處理「真正的管道」：

```text
git log | grep release
```

因為 `await X("git log")` 已代表 `git` 結束；它的輸出必須先完整存入 `A.Result`，再給下一個命令。大量輸出會佔記憶體，且沒有串流管道效果。

所以結論是：

- 你的 API 應該有，作為最簡單、最常用的「結果捕獲／重放」方式。
- 但若要功能完整，還必須有一條「進程尚在運行時取得 live stream」的低層 API；否則無法安全實現大輸出、即時日誌、互動輸入、真正管道。
- 高層 `X` 可預設把 stdout/stderr 捕獲到可讀 Stream；低層 API 才暴露正在運行的 process streams。普通腳本不需要碰低層。

另有一點必須定義：`A.Result` 若是記憶體 `Stream`，輸出無上限時可能爆記憶體；我建議高層 `X` 的捕獲結果改用暫存檔支援的 Stream，或設定可配置上限。這不是反對你的寫法，而是它要能長期可用必須處理的邊界。
````
	]
	
	-T[2026_0816_000018][
		那你能不能專門弄個函數 不是立即執行 而是拿到Stream的?
		Stream被消費就是執行
	][
````md
可以，而且這才適合你的寫法。

新增專門的惰性輸出函數：

```cs
await Write(Stdout, XOut("git status"));
await Write(File("status.txt"), XOut("git status"));
```

`XOut("git status")` 立刻只建立一個 `Stream`，不啟動進程；第一次 `ReadAsync`／被 `Write(...)` 消費時才啟動 `git status`，stdout 直接流出，不先整份存記憶體。

這能自然形成真正的管道：

```cs
await Write(
	XIn("grep release"),
	XOut("git log"));
```

上游 `XOut` 被讀取時啟動，下游 `XIn` 被寫入時啟動；兩端以 async `Stream.CopyToAsync` 串接，不需解析 `|`。

但有兩個必須明定的限制：

- `XOut` 只代表 stdout；stderr 不能放著不讀，否則子程序大量輸出 stderr 仍可能卡死。預設應直通靜態 `Stderr`，另提供 `XErr(...)` 取得 stderr stream。
- `Stream` 讀到 EOF 時，Cssh 必須等待子程序退出；若退出碼非 0，在該次讀取結束時丟 `CommandFailedException`。提早 `DisposeAsync` 則終止子程序。

三個靜態終端流：

```cs
Stdin   // 可讀：目前程序的標準輸入
Stdout  // 可寫：目前程序的標準輸出
Stderr  // 可寫：目前程序的標準錯誤
```

再配一個完全非同步的：

```cs
Task Write(Stream Target, Stream Source, CT Ct);
```

這套比「先 `await X` 再取 `Result`」更合理：不吃記憶體、真正串流，而且「消費 Stream 才執行」語義成立。
````
	]
	
	-T[2026_0816_000157][
		你這樣又複雜且不靈活了！
		一 你定義了一堆東西 又XIn 又XOut的
		二 你默認他只返回一個Stream了
		而不是返回DTO，Stream只是作爲DTO的字段！
		你自己不覺得嗎?
	][
````md
對，正確模型應是：

```cs
var A = X("git status"); // 只建立 DTO；尚未執行

await Write(Stdout, A.Stdout);
await Write(Stderr, A.Stderr);
```

定義 `Command` 為「一條尚未啟動的外部命令」：

```cs
public sealed class Command {
	public Stream Stdin { get; }
	public Stream Stdout { get; }
	public Stream Stderr { get; }
	public Task<Result> Done { get; }
}
```

- `X(...)` 回傳一個 `Command`，不是 Stream。
- 三條流都由同一個命令 DTO 持有。
- 第一次消費 `Stdin`／`Stdout`／`Stderr` 的任一條，才啟動該命令一次。
- 三條流可分別接到檔案、`Stdin/Stdout/Stderr` 靜態流、或另一個 `Command` 的對應流。
- `Done` 是非同步完成結果；只有在需要退出碼時才 `await A.Done`。

用法自然是：

```cs
var Git = X("git log");
var Grep = X("grep release");

var Copy = Write(Grep.Stdin, Git.Stdout);

await Write(Stdout, Grep.Stdout);
await Write(Stderr, Git.Stderr);
await Write(Stderr, Grep.Stderr);

await Task.WhenAll(Copy, Git.Done, Grep.Done);
```

這裡我必須指出一個真實邊界：若只消費 `A.Stdout` 而完全不消費 `A.Stderr`，子程式 stderr 輸出太多仍可能塞滿 OS pipe 而卡住。這不是 DTO 模型的問題，而是任何三流進程 API 都有的生命週期要求。

所以有一個需你決定的預設：

1. `A.Stderr` 若沒被消費，自動寫入靜態 `Stderr`；最適合腳本，不會死鎖。
2. 三條流都必須由呼叫方消費；最純粹、最可控，但很容易漏接而卡住。

我推薦 1。
````
	]
	
	-T[2026_0816_000530][
		Command爲甚麼有Stdin這個屬性?
		你告訴我 git status 這個命令的Stdin是甚麼?
	][
````md
沒有。`git status` 沒有「它自己的 stdin 結果」；我把進程的輸入端錯當成命令 DTO 的產物了。

正確分責：

```cs
var A = X("git status");
```

`A` 只應提供此命令產生的結果：

```cs
A.Result.Stdout
A.Result.Stderr
A.Done
```

若命令需要輸入，輸入是呼叫 `X` 時外部交進去的來源，不是 `A` 的屬性：

```cs
var A = X("tool", Input: Stdin);
var B = X("grep release", Input: A.Result.Stdout);
```

- `Stdin / Stdout / Stderr`：全域終端 Stream。
- `A.Result.Stdout / Stderr`：`A` 執行後產生的兩條輸出 Stream；消費時觸發執行。
- `Input`：可選的外部輸入 Stream。`git status` 不傳；需要讀輸入的工具才傳。

我上一版把「命令所接收的輸入」和「命令的結果」混在同一 DTO，設計錯了。
````
	]
	
	-T[2026_0816_000833][
		你的異步呢?
	][
````md
應該是這樣，所有可 I/O 的地方都以 async 為主：

```cs
var A = X("git status"); // 只建命令 DTO，不執行

await Write(Stdout, A.Result.Stdout, Ct);
await Write(Stderr, A.Result.Stderr, Ct);
var Exit = await A.Done;
```

- `X(...)`：同步，只建 DTO。
- `A.Result.Stdout / Stderr`：可讀 `Stream`；第一次 `ReadAsync` 時非同步啟動命令。
- `Write(...)`：`Task`，內部只用 `ReadAsync`／`WriteAsync`／`CopyToAsync`。
- `A.Done`：`Task<CommandExit>`；等待子程序退出並取得 exit code。
- `Ct`：取消讀寫時終止相關子程序並完成所有流。

管道也是非同步、自然串流：

```cs
var Git = X("git log");
var Grep = X("grep release", Input: Git.Result.Stdout);

await Write(Stdout, Grep.Result.Stdout, Ct);
await Task.WhenAll(Git.Done, Grep.Done);
```

這裡 `Grep.Result.Stdout` 被 `Write` 消費時，`grep` 非同步啟動；它讀 `Git.Result.Stdout` 時，`git` 也非同步啟動。沒有先完整緩存，也沒有阻塞等待。

你指出的更正後模型是：

```cs
Command
├── Result.Stdout : Stream  // 命令產物
├── Result.Stderr : Stream  // 命令產物
└── Done          : Task<CommandExit>

X(CommandText, Input: Stream?) -> Command
```

`Input` 是建立命令時外部傳入的來源；不是 `Command` 的 `Stdin` 屬性。`git status` 不傳 `Input`，它就從靜態 `Stdin` 繼承或直接關閉，這要再定預設。
````
	]
	
	-T[2026_0816_001242][
		那你改decl 然後 另出一個綜合一點的csx 儘量包含各種場景
	][
		
	]
	
	-T[2026_0816_111641][
		把Ct弄成可選參數！腳本就不要到處傳Ct了
	][
		
	]
	
	-T[2026_0816_111822][
算了 就這樣吧。 這樣:  有Ct的是異步 沒Ct的是同步。
對于只有一條線 從頭按順序執行到尾的程序
全異步+await 和 全同步 都一樣 是不是?
	][
````md
是。對於單條、嚴格按順序的腳本：

```cs
A();
B();
C();
```

與：

```cs
await A(Ct);
await B(Ct);
await C(Ct);
```

在執行順序與總耗時上基本一樣；後者不會憑空變快。

差別在於 async 版本可：

- 不阻塞呼叫執行緒；
- 接受取消；
- 與其他並行工作交錯；
- 非同步等待 I/O，不長時間佔住執行緒。

但 `.csx` 建構腳本通常就是單線順序流程，所以同步 API 應是主寫法，最乾淨：

```cs
Mkdir("publish");
X("dotnet publish -c Release");
Cp("publish", "publishNoPdb");
```

有 `Ct` 的 overload 才是 async 版：

```cs
await Mkdir("publish", Ct);
await X("dotnet publish -c Release", Ct: Ct);
await Cp("publish", "publishNoPdb", Ct: Ct);
```

需要修正一點：命令的 stdout/stderr stream、真正的管道，內部仍必須以 async 實作，否則會死鎖；但普通腳本呼叫端不需要因此滿篇 `await`。
````
	]
	
	-T[2026_0816_112034][
		能不能不要出現 `Ct: Ct` 這種?
		直接最後一個參數傳Ct。
		你不要把API參數弄這麼複雜
		如果你有很多可選參數就封裝成DTO
	][
		
	]
	
	-T[2026_0816_112432][
		我查了一下 bash裏面rm的參數,
		他是這樣說的:
		````md
		-f 具体就干两件事：① 文件不存在时不报错（方便脚本）；② 删文件不问我（省得按 y）。但遇到文件夹本身没写权限，加多少个 -f 都没用。
		````
		你的Force: true也是和他一樣的功能嗎?
		如果是 那就完全沒必要抄他的force
		直接讓cssh的Rm等於rm -rf 不就好了?
		
	][
		
	]
	

	
	-T[2026_0816_114807][
		給 string 類型重寫一個 除號 操作符、相當於路徑拼接。
	][
		
	]
	
	
	-T[2026_0816_113915][
		測試項目裏面,
		你再加一個綜合的測試用例。
		你仿照數據庫測試的思路。
		在測試入口的同目錄下面先新建文件夾
		然後在裏面放文件。
		然後各自測功能
		測試要結束的時候最後清掉這個文件夾。
		理解我意思嗎?
		我一會要檢查你的用例寫法
		重審API設計
		我說的這些是讓你寫在一個用列裏的！
	][
		
	]
	
	
	-T[2026_0816_124527][
		你這Read Write怎麼全是的字符串? 爲甚麼這麼設計? 爲甚麼不用Stream?
	][
````md
這個設計不對，是我把「方便」錯放成主 API 了。

現有：

```cs
Read(Path) -> string
Write(Path, Content) -> void
```

只適合 UTF-8 小文字檔，卻讓最基本的 `Read/Write` 失去二進位、大檔串流、編碼控制與管道能力；而 `OpenRead/OpenWrite` 反而被迫當成真正的核心 API，命名顛倒了。

應改成：

```cs
Stream Read(string Path);
Stream Write(string Path);        // 覆寫，等價於 >
Stream Append(string Path);       // 追加，等價於 >>
```

然後文字版明確叫：

```cs
string ReadText(string Path);
void WriteText(string Path, string Text);
void AppendText(string Path, string Text);
```

或甚至只保留 Stream API，文字由使用者自行用 `StreamReader/StreamWriter` 處理。

這樣才和你定下的「所有輸入輸出都是 Stream」一致。`OpenRead/OpenWrite/OpenAppend` 也應移除或改名，不能讓 `Read/Write` 綁死 string。
````
	]
	
	-T[2026_0816_124557][
		爲甚麼Write 是返回Stream 而不是傳入Stream?
	][
````md
不該返回 `Stream`。你說得對。

`Read(path)` 的方向是「檔案 → 呼叫方」，所以回傳 `Stream` 合理。

但 `Write` 的方向是「呼叫方 → 檔案」，應該接收來源 `Stream`：

```cs
Write("output.bin", Input);
Append("output.log", Input);
```

也就是：

```cs
Stream Read(string Path);
void Write(string Path, Stream Source);
void Append(string Path, Stream Source);
```

文字版才是額外 helper：

```cs
ReadText(Path);
WriteText(Path, Text);
```

若要取得可寫入的目標流，應叫 `OpenWrite`／`OpenAppend`，不能偷換成 `Write`。我前面把 `>` 的「開啟目標」和 `Write` 的「轉送來源」混了，設計錯了。
````
	]
	
	-T[2026_0816_153305][
		Stream功能最全
		String最常用,
		只設計Stream 不設計String 用起來不方便,
		只設計String不設計Stream用起來缺功能。
		你想想怎麼解決這個問題
		想幾種方案
	][
````md
核心衝突只在 `Read`：C# 不能只靠回傳型別區分 `Stream Read(path)` 和 `string Read(path)`。

方案一，我推薦：Stream 是核心；文字是同名寫入 overload + 明確的讀文字名。

```cs
Stream Read(string Path);

void Write(string Path, Stream Source);
void Write(string Path, string Text);

void Append(string Path, Stream Source);
void Append(string Path, string Text);

string ReadText(string Path);
```

異步完全對應、`Ct` 最後：

```cs
Task<Stream> Read(string Path, Ct);
Task Write(string Path, Stream Source, Ct);
Task Write(string Path, string Text, Ct);
Task<string> ReadText(string Path, Ct);
```

腳本最常見的寫法仍短：

```cs
Write("a.txt", "hello");
var Text = ReadText("a.txt");

await Write("out.bin", Command.Result.Stdout, Ct);
await Write("out.txt", "hello", Ct);
```

而所有二進位、管道、大檔場景不受限：

```cs
await using var Input = await Read("archive.tar", Ct);
await Write("copy.tar", Input, Ct);
```

方案二：`Read` 接收目標 Stream，完全避免 `ReadText` 這個名字。

```cs
void Read(string Path, Stream Target);
void Write(string Path, Stream Source);

string Text(string Path);
void Text(string Path, string Content);
```

```cs
Read("a.bin", Stdout);
Write("b.bin", Command.Result.Stdout);
var S = Text("a.txt");
Text("a.txt", "hello");
```

優點是 I/O 動詞全是轉送；缺點是常見的「取得檔案流供後續組合」不自然，且 `Text` 同時讀寫語義較含混。

方案三：保留 `OpenRead/OpenWrite` 作低階 API，另設高階傳送 API。

```cs
Stream OpenRead(string Path);
Stream OpenWrite(string Path);
void Write(string Path, Stream Source);
void Write(string Path, string Text);
string ReadText(string Path);
```

這是功能最全，但 API 數量最多；`OpenWrite` 對應「我要自己控制目標流生命週期」，`Write` 對應「把現成資料寫入去」。我認為它可作為方案一的補充，而不是獨立主張。

我建議採方案一加上 `OpenWrite/OpenAppend`：

- `Read`：回傳 Stream
- `Write/Append`：來源可為 Stream 或 string
- `ReadText`：唯一因 C# 回傳型別限制而需要後綴的常用 helper
- `OpenWrite/OpenAppend`：只給確實要手動持有可寫流的少數情況
- 所有文字 helper 預設 UTF-8；特殊編碼放 `TextOptions` DTO，不散落可選參數。
````
	]
	
	-T[2026_0816_153546][
		你的方案都不優雅,
		又要另外定義一堆api,
		能不能從Stream和String互轉上着手?
	][
````md
可以從轉換做，讓檔案 API 不分出 `ReadText`／`WriteText` 一大堆名字。

方案一：隱式轉換，表面最短。

```cs
Stream Read(string Path);
void Write(string Path, Stream Source);
void Append(string Path, Stream Source);
```

在 `string` 與 `Stream` 上用 C# 14 extension conversion：

```cs
string Text = Read("a.txt");
Write("a.txt", "hello");
await Write("build.log", Cmd.Result.Stdout, Ct);
```

`string → Stream` 很自然；`Stream → string` 則預設 UTF-8、讀到結尾、不關閉原 Stream。

問題：轉成 `string` 必然完整消費 Stream，且 conversion operator 不能 `await`。所以：

```cs
string Text = await Read("a.txt", Ct);
```

雖然表面有 `await`，實際讀文字那一步仍是同步，違反異步優先。這方案只適合同步文字讀取很常見、且接受這個代價時。

方案二：保留同一套 Stream API，加兩個「轉換」extension；我較推薦。

```cs
Stream Read(string Path);
void Write(string Path, Stream Source);
void Append(string Path, Stream Source);
```

只新增：

```cs
Stream Stream(this string Text);             // UTF-8 字串來源
string Text(this Stream Source);             // 同步消費
Task<string> Text(this Stream Source, CT Ct);// 非同步消費
```

使用：

```cs
var Text = Read("a.txt").Text();

await Write("a.txt", "hello".Stream(), Ct);
var Text = (await Read("a.txt", Ct)).Text(Ct);

await Write("build.log", Cmd.Result.Stdout, Ct);
```

優點是檔案 API 永遠只談 Stream；文字只是資料轉換。異步語義也是真的異步。缺點是文字寫入多一個 `.Stream()`。

方案三：統一包一個 `Content`。

```cs
Content Read(string Path);
void Write(string Path, Content Source);
```

`Content` 持有 Stream，可與 `string`、`Stream` 隱式互轉：

```cs
string Text = Read("a.txt");
Write("a.txt", "hello");
Write("a.txt", Cmd.Result.Stdout);
```

但 `Content` 本身要處理 Stream 是否已消費、是否該 Dispose、字串轉換是否同步等生命週期；表面最漂亮，內部語義最容易變混亂。我不推薦。

我的建議是方案二：

- `Read/Write/Append` 一律只以 Stream 為核心。
- `Text()`／`Stream()` 是通用資料轉換，不是每個檔案 API 各做一套文字版本。
- `Text(Stream, Ct)` 讓文字讀取仍保持真正異步。
- UTF-8 為預設；編碼需求用一個 `TextOptions` DTO。
````
	]
	
	-T[2026_0816_153926][
		在項目裏自己定義一個Stream的子類,
		然後所有API都引用自己的Stream
		並實現與String的互相隱轉轉換
		和 與普通Stream的互相隱式轉換
		這樣行不行?
	][
````md
不行，至少「自己的 `Stream` 子類」+「和普通 `System.IO.Stream` 雙向隱式轉換」這組合在 C# 裡做不了。

原因：

```cs
class ShStream : System.IO.Stream
```

已天然支援：

```cs
System.IO.Stream A = ShStreamValue; // 子類 → 父類，隱式
```

但反向：

```cs
ShStream B = OrdinaryStream;
```

C# 禁止為「父類 → 子類」定義 user-defined conversion。即使強行 cast 也不安全：普通 `FileStream` 根本不是 `ShStream`。

另外 `Stream → string` 的隱轉也有本質問題：它必須消費整條流，且不能 `await`，只能偷做同步讀取，不應設成隱式。

能成立的變體是：定義自己的「內容包裝類」，但它不能繼承 `System.IO.Stream`，例如 `Content`：

```cs
Content A = "hello";              // string → Content
Content B = OrdinaryStream;       // Stream → Content
System.IO.Stream C = B;           // Content → Stream
```

然後 API 統一：

```cs
Content Read(string Path);
void Write(string Path, Content Source);
```

但 `Content → string` 仍應是明確且可異步的：

```cs
var Text = await Content.Text(Ct);
```

不能做可靠的隱式轉換。

所以若目標是 API 簡潔，我建議用非 `Stream` 子類的 `Content`／`Data` 包裝；若堅持繼承 `Stream`，就只能接受普通 `Stream` 要顯式 `Wrap(...)`，無法雙向隱轉。
````
	]
	
	-T[2026_0816_154303][
		那按Content模式的話
		不是仍可以加隱式轉換嗎?
		string轉Content沒甚麼問題吧?
		Content隱式轉string就讓他同步,
		要異步的時候纔用.Text函數
	][
````md
可以，這個設計成立。我剛才把「不能隱轉」說得太死了；不能的是 `System.IO.Stream` 父子類那條路，不是 `Content` 包裝類。

```cs
public sealed class Content {
    public static implicit operator Content(string Text);
    public static implicit operator Content(Stream Stream);

    public static implicit operator string(Content Value); // 同步讀完
    public static implicit operator Stream(Content Value); // 取底層 Stream

    public Task<string> Text(CT Ct); // 非同步讀完
}
```

那檔案 API 就能只保留一套：

```cs
Content Read(string Path);

void Write(string Path, Content Source);
void Append(string Path, Content Source);
```

使用面：

```cs
Write("a.txt", "hello");            // string 隱轉 Content
string Text = Read("a.txt");        // Content 同步隱轉 string

await Write("log.txt", Cmd.Result.Stdout, Ct); // Stream 隱轉 Content
var Text = await Read("a.txt", Ct).Text(Ct);
```

這個方案可行，但必須明確定一條規則：`Content` 是一次性資料流。轉成 `string`、寫入檔案、或讀取其 `Stream` 都會消費底層流；若要再次使用，呼叫方必須自行先複製或重新取得來源。否則同一 `Content` 既隱轉字串又拿去寫檔，第二次會得到空資料，語義會很危險。

我建議採這個方向。
````
	]
	
	-T[2026_0816_154659][
		那你先去改一版decl 和 綜合測試用例, 讓我看看效果, 實現部分先不寫
	][
		
	]
	

	
	-T[2026_0816_160614][
		看 `E:\_code\Ngan\Ngan.Dict\Ngan.Dict.Scripts\Ngan.Dict.Scripts.csproj`
		讓這個程序集當作Ngan.Dict專用的腳本程序集。
		定義多個入口的Main方法,
		運行時 用dotnet run在命令行中指定入口。
		把
		- `E:\_code\Ngan\PublishWeb.sh`
		- `E:\_code\Ngan\PublishWin.sh`
		- `E:\_code\Ngan\PublishLinux.sh`
		- `E:\_code\Ngan\PublishAndroid.sh`
		- `E:\_code\Ngan\Ngan.Dict\Ngan.Dict.Frontend\proj\Ngan.Dict.Android\PublishNativeAot.sh`
		- `E:\_code\Ngan\CpAssets.sh`
		這些東西 重寫一份C\#版的。
	
	][
````md
有一個 C# 語言層面的衝突要先確認：

`dotnet run` 不能在執行時直接選擇多個真正的 `Main`。多個 `Main` 會編譯報錯；`StartupObject` 是編譯時指定，不能寫成：

```powershell
dotnet run PublishWeb
```

我建議實作為單一 dispatcher 入口：

```powershell
dotnet run --project Ngan.Dict/Ngan.Dict.Scripts -- PublishWeb
dotnet run --project Ngan.Dict/Ngan.Dict.Scripts -- PublishWin
dotnet run --project Ngan.Dict/Ngan.Dict.Scripts -- PublishLinux
dotnet run --project Ngan.Dict/Ngan.Dict.Scripts -- PublishAndroid
dotnet run --project Ngan.Dict/Ngan.Dict.Scripts -- PublishAndroidNativeAot
dotnet run --project Ngan.Dict/Ngan.Dict.Scripts -- CpAssets
```

各腳本類仍各自定義 `Main` 方法，但由 `Program.Main` 按第一個參數 dispatch。這符合「命令行指定入口」且可編譯。

你確認用這個入口形式後，我就開始寫六份實作。
````
	]
	
	-T[2026_0816_162653][
		你這裏是不是還缺 文件/文件夾屬性的 API?
		做完上面的東西之後去補一下
	][
````md
缺，而且目前 `FileSystemEntry` 只夠「辨認種類」，不夠腳本作判斷或管理。

我建議新增一個統一 DTO，不把所有屬性塞進 `LsOptions`：

```cs
public sealed record FileSystemInfo(
    string Path,
    string Name,
    bool IsFile,
    bool IsDir,
    bool IsLink,
    long Size,
    DateTimeOffset LastWriteTime,
    DateTimeOffset LastAccessTime,
    DateTimeOffset CreationTime,
    FileAttributes Attributes,
    UnixFileMode? UnixMode);
```

並提供：

```cs
FileSystemInfo Stat(string Path);
Task<FileSystemInfo> Stat(string Path, Ct);

void Chmod(string Path, UnixFileMode Mode);
Task Chmod(string Path, UnixFileMode Mode, Ct);

void Touch(string Path);
Task Touch(string Path, Ct);
```

同時讓 `Ls`／`Find` 回傳 `FileSystemInfo`，不再維護較弱的 `FileSystemEntry`。

其中：

- `Size`：檔案 bytes；資料夾為 `0`，不遞迴計算。
- 三個時間都用 `DateTimeOffset`。
- `Attributes` 保留 Windows readonly／hidden 等跨平台 BCL 屬性。
- `UnixMode` 只在 Unix 有值；Windows 為 `null`。
- `Chmod` 在 Windows 應丟 `PlatformNotSupportedException`，不能假裝成功。
- `Touch`：不存在則建立空檔；存在則更新最後寫入時間，對標 Bash。

需要你確認的是範圍：這一版是否要包含會修改 metadata 的 `Chmod` 與 `Touch`，還是先只做 `Stat` + 擴充 `Ls/Find` 回傳屬性？
````
	]
	
	-T[2026_0816_163805][
		不要chmod和touch。
		文件/文件夾屬性 用.net 庫裏面 自帶的。
	][
````md
明白：不做 `Chmod`、`Touch`，也不自訂 `UnixMode`／自訂屬性 DTO；直接用 .NET 的 `FileAttributes`。

我需要你定一點：要不要讓 `Ls`／`Find` 直接回傳 .NET 的 `FileSystemInfo`（實際會是 `FileInfo` 或 `DirectoryInfo`）？

```cs
foreach (var Item in Ls()) {
    if (Item is FileInfo File)
        Echo(File.Length.ToString());

    if (Item.Attributes.HasFlag(FileAttributes.Hidden))
        ...
}
```

這最符合「用 .NET 自帶屬性」，但會取代目前自訂的 `FileSystemEntry.IsFile/IsDir/IsLink`。
````
	]
	
	-T[2026_0816_163956][
		可
	][
		
	]
	
	-T[2026_0816_165145][
`E:\_code\Ngan\Ngan.Dict\Ngan.Dict.Scripts\ScriptContext.cs`
你tm又搞這個東西幹甚麼?
而且又不按decl impl拆分?
又自己造一輪不共享的輪子?
你看我原來的bash腳本造輪子了嗎?
給我個解釋
	][
````md
你說得對，這個 `ScriptContext` 是我過度抽象了。

它塞了三件不該塞進 Ngan.Dict 腳本層的事：

- 向上搜尋工作區根目錄：原 Bash 明確假定從 repo root 執行，再用相對 `cd`；我自作主張加「從任何目錄都能跑」的機制，改變了原腳本的契約。
- `XTerm`：重複包裝 CsSh 的命令／輸出轉送，不是 Ngan.Dict 業務邏輯。這應由 CsSh 提供，或腳本直接寫明，不該藏在一個 Ngan.Dict helper。
- `CopyContents`：為 `cp -r source/* dest` 補語義，卻又造了局部輪子，沒有先收斂到 CsSh 的通用檔案 API。

你指出的 decl/impl 問題也成立：雖然 `XTerm`、`CopyContents` 有 `.Impl.cs`，但 `FindRoot()` 的方法體仍寫在 [ScriptContext.cs](E:\_code\Ngan\Ngan.Dict\Ngan.Dict.Scripts\ScriptContext.cs)，違反聲明／實現分離。

正確方向是刪掉 `ScriptContext`：

- 腳本依原 Bash 的 repo-root 工作目錄假設直接寫相對路徑。
- `Cd`、`X`、`Cp`、`Find` 直接使用 CsSh。
- 若命令輸出轉送、目錄內容複製確實是通用缺口，應先補到 `Tsinswreng.CsSh`，不能在 Ngan.Dict.Scripts 私造。
````
	]
	
	-T[2026_0816_165428][
		有用的公共API你得往CsSh裏面補啊
		腳本 不要依賴cwd
		弄成在哪裏都能跑最好
	][
````md
我剛才只動了 CsSh 的宣告，尚未實作，也尚未刪 `ScriptContext`。

三個公共 API 的意思是：

```cs
XTerm("dotnet publish -c Release", Ct);
```

就是現在 `ScriptContext.XTerm` 做的事：建立命令、同時把 stdout 寫到 `Stdout`、stderr 寫到 `Stderr`、等待退出碼。它不屬於 Ngan.Dict，所有 build script 都需要，所以應放 CsSh。

```cs
await CpContents("ExternalRsrc", "some/output", Ct);
```

等價 Bash：

```bash
cp -r ExternalRsrc/* some/output
```

它複製「資料夾內部所有項目」到目標，而不是目前 `Cp("ExternalRsrc", "some/output")` 那種把整個 `ExternalRsrc` 目錄再嵌一層。`CpAssets.sh` 正需要這個語義，因此原本的 `ScriptContext.CopyContents` 不該私有存在。

```cs
var Root = await FindUp("Ngan.Dict", AppContext.BaseDirectory, Ct);
```

從 DLL 所在目錄一路往父目錄找，直到找到「直接包含 `Ngan.Dict`」的目錄，回傳它。這讓：

```powershell
dotnet run --project E:\_code\Ngan\Ngan.Dict\Ngan.Dict.Scripts -- PublishWin
```

無論當前 cwd 在哪裡都可用，且不是 Ngan.Dict 特例；任何 C# build script 都可能需要。

不過有一個我該先問、而不是直接加 API 的設計問題：

`FindUp` 是否應接受「一個子項名稱」如 `"Ngan.Dict"`，還是應接受多個必須同時存在的標誌項目，例如：

```cs
FindUp(["Ngan.Dict", "ExternalRsrc"], AppContext.BaseDirectory, Ct)
```

Ngan.Dict 現在原本需兩個標誌才能確認是 repo root；單一 `"Ngan.Dict"` 可能在其他巢狀目錄誤命中。我的建議是直接設計成多個 `Markers`。
````
	]
	
	-T[2026_0816_170308][
		第一個,
		爲甚麼不能用X?
		第二個,
		能不能寫`Cp("ExternalRsrc/*", ...)`?
		第三個,
		AppContext.BaseDirectory 是甚麼?
		行爲是甚麼?
		能不能在csx中用?
		與CallerPath區別?
	][
````md
1. `XTerm` 不必另造。

`X` 現在的定位是「建立可組合的 lazy command」：

```cs
var Cmd = X("git log", Ct);
await Write("log.txt", Cmd.Result.Stdout, Ct);
```

若只想直通終端，應由 `X` 自己提供一個最短的「消費」方式，而不是 scripts 再包 `XTerm`。例如：

```cs
await X("dotnet publish -c Release", Ct);
```

讓 `await Command` 的語義不只等退出，也預設把兩條輸出寫到目前終端。  
但這會和「我只想等待、不顯示輸出」衝突；所以更合理的是保留 `X` 的純 DTO 語義，腳本直接明寫一次：

```cs
var X = X("dotnet publish -c Release", Ct);
await Task.WhenAll(
    Write(Stdout, X.Result.Stdout, Ct),
    Write(Stderr, X.Result.Stderr, Ct),
    X.Done);
```

這確實太長。要怎麼縮短，應重設 `Command` 本身的消費 API，而不是加 `XTerm` 這個額外動詞。這點我應先跟你定，而不是先塞 API。

2. 可以，而且比 `CpContents` 好：

```cs
await Cp("ExternalRsrc/*", Destination, Ct);
```

應把 `Cp` 的 `Source` 定義為「路徑或 glob」：

- 無 glob：維持現有複製單一檔案／整個目錄。
- 有 glob：把每個匹配項複製到 `Destination` 的直接子項，等價 Bash `cp -r source/* destination`。
- `**` 可沿用 `Find` 的 glob 規則。

這樣不需要 `CpContents`。

3. `AppContext.BaseDirectory` 是「目前 .NET 程序集被載入／執行的基準目錄」，不是 cwd。

正常 `dotnet run` 時通常是：

```text
<project>/bin/Debug/net10.0/
```

發佈後通常是 publish 目錄。它不會因 `Cd()` 改變。

在 `csx` 中不能把它當腳本目錄：`dotnet-script` 通常把腳本編譯到自己的暫存／快取目錄，因此它多半指向暫存執行目錄，不是 `.csx` 所在目錄。

`CallerPath` 指 `[CallerFilePath]`：

```cs
string CallerPath([CallerFilePath] string Path = "")
```

編譯器在呼叫點把「呼叫者的原始碼檔路徑」塞進參數。

差別：

| API | 代表 |
|---|---|
| `Environment.CurrentDirectory` / `Pwd()` | 程序目前工作目錄；會被 `Cd` 改變 |
| `AppContext.BaseDirectory` | 執行程序集／host 的載入目錄；不隨 `Cd` 改變 |
| `CallerPath` | 編譯時呼叫該 API 的 `.cs`／`.csx` 原始檔位置；不依賴執行位置 |

在 `.csx`，`CallerPath` 理論上可得到 `.csx` 檔案路徑，且比 `AppContext.BaseDirectory` 適合找腳本所在位置；但它是「每次呼叫點」的資訊，若從另一個 helper `.cs` 再間接呼叫，得到的是 helper 檔案，不是最外層 `.csx`。

對 `Ngan.Dict.Scripts` 這種已編譯程序集，最直接可靠的是 `CallerPath`：`Program.cs`／各入口 `.cs` 的原始碼路徑本來就在 repo 裡，可由其父層推出 repo root。它不依賴 cwd，也不用往上猜 `AppContext.BaseDirectory`。
````
	]
	
	-T[2026_0816_171843][
		那從實際的Bash腳本來看,
		調用外部命令 都是默認寫stdout和stderr的。
		是不是設計成:
		X默認輸出,
		另建不輸出的API
		更好?
		
		還是X不輸出,
		`X().Out()`再寫入stdout和stderr?
		這樣能少定義點API
	][
````md
從 Bash 語義看，外部命令的預設確實是繼承目前的 stdout/stderr。

我建議不要 `XTerm`，也不要 `X().Out()`；用：

```cs
await X("dotnet publish -c Release", Ct);
```

語義：

- `X(...)`：建立可組合的 `Command` DTO，不立即執行。
- `await Command`：預設把 stdout 寫到 `Stdout`、stderr 寫到 `Stderr`，並等待退出。
- 要自訂輸出／管道時才直接消費 `Result`：

```cs
var Cmd = X("git log", Ct);
await Write("log.txt", Cmd.Result.Stdout, Ct);
await Write(Stderr, Cmd.Result.Stderr, Ct);
await Cmd.Done;
```

這樣普通腳本就是 Bash 式預設輸出，且不新增 `XTerm` 或 `Out()` API；只有真正要改輸出流向時才展開。

「不輸出」也不需要新 API：

```cs
var Cmd = X("tool", Ct);
await Task.WhenAll(
    Write(Null, Cmd.Result.Stdout, Ct),
    Write(Null, Cmd.Result.Stderr, Ct),
    Cmd.Done);
```

相比 `X().Out()`，這避免多一個只為「預設行為」存在的方法，而且 `await X(...)` 是最自然的腳本結尾語法。
````
	]
	
	-T[2026_0816_172429][
		那就不默認輸出。
		但是你寫
````cs
await Task.WhenAll(
    Write(Null, Cmd.Result.Stdout, Ct),
    Write(Null, Cmd.Result.Stderr, Ct),
    Cmd.Done);
````
這個就很麻煩 你想要輸出的地方就得寫這麼多。
能不能在這裏簡化一下
	][
````md
可以。就用你提的 `X().Out()`，但讓 `X` 本身永遠不輸出。

```cs
await X("dotnet publish -c Release", Ct).Out(Ct);
```

明確表示「執行並輸出到目前終端」。

三個足夠：

```cs
// stdout → Stdout；stderr → Stderr
await X("dotnet publish", Ct).Out(Ct);

// stdout、stderr 都丟棄
await X("tool", Ct).Out(Null, Ct);

// 分別指定 stdout 與 stderr 去向
await X("tool", Ct).Out(Log, Null, Ct);
```

`Out` 回傳 `Task<CommandExit>`，所以可直接 `await`；非零退出仍依 `X`／`TryX` 原本的失敗策略處理。

這比 `Task.WhenAll(Write(...), Write(...), Done)` 短很多，也不新增 `XTerm`。  
需要手動管道、不同步消費或保存 `Result` 時，才不呼叫 `Out()`，直接處理 `Cmd.Result`。
````
	]
	
	-T[2026_0816_172701][
		那你就用 CallerPath,
		暫時自己 `CallerPath / ".."` 來找根目錄
		先不用自己封裝。
		然後X這個按我說的改。
	][
		
	]
	
	
	-T[2026_0816_185731][
		你到處new(Cwd: ProjectDir)不覺得又醜又反直覺嗎? 人家寫bash的時候都是cd的 你不能優先Cd?
	][
		
	]
	
	-T[2026_0816_185742][
		把你的Sh改成 實例的, 而不是全靜態的。
````cs
public class Sh{
	public partial str Pwd(); //不要static
}

public class ShStatic{
	public static Sh Sh{get;set;} = new();
	public static str Pwd()=>Sh.Pwd();
}
````
這樣行不行?
既靈活 也方便using static。
幾種調用寫法:
+ #[using static ShStatic;]
+ #[
```cs
//複雜
ShStatic.Pwd();
ShStatic.Cp(...)
ShStatic.DoSomething(...)
```
]
+ #[
```cs
var sh = ShStatic.Sh;
sh.Pwd();
sh.Cp(...)
sh.DoSomething(...)
```

]
不一定要叫ShStatic這個名字 有更好的也可以說
	][
````md
可以，而且比現在的全靜態設計更靈活。但你給的結構需要稍微調整。

我的推薦是：

```cs
public partial class Sh{
	public partial str Pwd();
	public partial void Cd(str Path);
	public partial Command X(str Command, CT Ct);
	public partial Task<nil> Write(Content Target, Content Source, CT Ct);
}

public static partial class ShGlobal{
	public static Sh Sh{get;} = new();

	public static str Pwd(){
		return Sh.Pwd();
	}

	public static void Cd(str Path){
		Sh.Cd(Path);
	}

	public static Command X(str Command, CT Ct){
		return Sh.X(Command, Ct);
	}
}
```

使用方式：

```cs
using static Tsinswreng.CsSh.ShGlobal;

Cd("src");
await X("dotnet build", Ct).Out(Ct);
```

或：

```cs
ShGlobal.Cd("src");
await ShGlobal.X("dotnet build", Ct).Out(Ct);
```

或：

```cs
var Sh = ShGlobal.Sh;
Sh.Cd("src");
await Sh.X("dotnet build", Ct).Out(Ct);
```

`ShStatic` 可以用，但我更建議叫 `ShGlobal`：

- `ShStatic` 像是在描述實現方式。
- `ShGlobal` 表示它是全局預設實例的 facade。
- `Sh` 保留給真正的實例類型。

需要注意一個重要問題：`Cd` 的狀態應該屬於實例，而不是直接修改 `Environment.CurrentDirectory`。

推薦：

```cs
var A = new Sh();
var B = new Sh();

A.Cd("project-a");
B.Cd("project-b");
```

此時：

- `A.Pwd()` 是 `project-a`
- `B.Pwd()` 是 `project-b`
- `A.X(...)` 使用 `project-a`
- `B.X(...)` 使用 `project-b`

這樣多個腳本上下文才不會互相干擾。`ShGlobal.Sh` 仍然提供 Bash 風格的單線程預設體驗。

方案比較：

| 方案 | 設計 | 優點 | 缺點 |
|---|---|---|---|
| A，推薦 | `Sh` 實例 + `ShGlobal` 靜態 facade | 同時支援依賴注入、測試、`using static`、Bash 風格 | facade 需要轉發方法 |
| B | `Shell` 實例 + 保留現有靜態 `Sh` | 向後兼容最好 | 實例類型不叫 `Sh`，命名不如你的想法自然 |
| C | 只有 `Sh` 實例，腳本自己 `var Sh = new Sh()` | 沒有轉發重複 | 失去 `using static` 的簡潔寫法 |

我建議採用方案 A，並讓 `ShGlobal` 的轉發層也拆成 declaration / implementation；後續可以用 source generator 或共用內部實作避免手寫邏輯重複。

這會是一次 API breaking change：現有的 `Sh.X(...)`、`using static Sh` 都要改成 `ShGlobal.X(...)` 或 `using static ShGlobal`。如果你確認採方案 A，我再按這個方案改 declaration、implementation、測試和所有腳本。
````
	]
	
	-T[2026_0816_191328][
		那就按你說的做。
		已有代碼都用簡化的 using static的寫法。
	][
		
	]
	
	-T[2026_0816_205137][
還是把X改成 默認.Out的比較好。
當前的 需要手動Out的X給他改個名
這樣更符合直覺。
不然容易漏寫Out 命令就不執行了
不是嗎?
你覺得呢
說一下你的想法
	][
````md
我同意。現在的 `X` 是最常用命令 API，卻是惰性的；漏掉 `.Out()` 或 `.Done` 就完全不執行，太容易踩坑。

我建議改成：

```cs
await X("dotnet build", Ct);          // 立即執行；預設 stdout/stderr 寫終端
var Exit = await TryX("git diff", Ct); // 同樣輸出；非零退出不拋例外
```

把目前惰性、可取雙 Stream 的 API 改名為 `Cmd`：

```cs
await using var Cmd = Cmd("git status", Ct);
await Cmd.Out("status.log", Ct);

await using var Upstream = Cmd("git log --oneline", Ct);
await using var Downstream = Cmd(
    "git hash-object --stdin",
    new(Input: Upstream.Result.Stdout),
    Ct);
```

對應關係：

| 目的 | API |
|---|---|
| 普通腳本命令，直接顯示輸出 | `await X(...)` |
| 非零退出也繼續 | `await TryX(...)` |
| 管道、自己取 stdout/stderr、寫檔、延遲執行 | `Cmd(...)` / `TryCmd(...)` |

`Cmd` 比 `XQuiet`、`XRaw` 清楚：它明確表示「拿命令 DTO」，不是「執行命令」。我建議這樣改。
````
	]
	
	-T[2026_0816_211931][
		看 `E:\_code\_Tvs\_Mvn\Mvn.csx`
		還有一個問題,
		用Cmd的時候 要傳字符串參數怎麼傳?
		必須自己加`"`然後自己處理轉義嗎?
	][
````md
要自己加引號，現在的 `Cmd` 不會替你跳脫。

例如 `Mvn.csx` 現在這樣：

```cs
Cmd($"{Typst} compile --root \"{Root}\" \"{Source}\" \"{Destination}\"", Ct)
```

這有兩個問題：

- 路徑包含空白時必須手寫 `"`。
- 路徑本身含 `"`、尾端反斜槓等情況，呼叫端還得自己做 Windows 命令列跳脫；容易錯。

我建議補一個小型引用函數，例如 `Q`：

```cs
await Exe($"{Typst} compile --root {Q(Root)} {Q(Source)} {Q(Destination)}", Ct);
```

`Q(string)` 不做 shell 解析；它只按 `ProcessStartInfo.Arguments` 的 Windows 規則產生「單一參數」的安全引號／跳脫字串。這正好符合目前「第一段是可執行檔，其餘保持原始 arguments」的設計。

另一種是 `Cmd(string Exe, params string[] Args)`，但你先前已明確不想強制可執行檔與參數分開，所以我不建議把它當主 API。`Q(...)` 最適合現在的字串腳本寫法。
````
	]
	
	-T[2026_0816_212325][
		如果用string[] args就不用自己處理轉義嗎?
	][
````md
對。若 API 收 `string[] Args`，庫內可用 `ProcessStartInfo.ArgumentList.Add(...)`，.NET 會處理平台正確的引號與跳脫：

```cs
await Exe(
    Typst,
    ["compile", "--root", Root, "--format", Format, Source, Destination],
    Ct);
```

呼叫端完全不用處理空白、引號、尾端反斜槓。

但它的代價是普通腳本會變長，而且跟你要的 Bash 式：

```cs
await Exe($"typst compile --root {Q(Root)} ...", Ct);
```

相比不夠順手。

所以我建議兩者都要：

- 主力短寫法：`Exe($"...", Ct)` + `Q(...)`
- 完全不想處理跳脫、參數來自外部輸入或動態資料時：`Exe(Exe, Args, Ct)`

前者方便，後者最穩。
````
	]
	
	-T[2026_0816_212939][
		那你加一下重載。
		如果參數是 `(string, IList<string>, ...)`的話那就是自己分隔參數。
		Q函數也做一份。
	][
	]
	
	-T[2026_0816_214826][
		改一下Mvn.csx、
		讓他同步最新的API。
		能用 `IList<str>`參數的就用 不要用Q 更不要手動轉義。
		然後代碼風格也不合規範。if和for好多都沒有大括弧。
	][
		
	]
	
	-T[2026_0816_221908][
````md
File: e:\_code\_Tvs\_Mvn\Mvn.csx
181: 	var Stdout = Command.Result.Stdout.Text(Ct);
182: 	var Stderr = Command.Result.Stderr.Text(Ct);
183: 	await Task.WhenAll(Stdout, Stderr, Command.Done);   你每次拿外部命令輸出都得這麼寫是嗎
````
	][
````md
不該。這是 CsSh 缺一個「一次取完兩條輸出」的終端消費 API。

建議新增：

```cs
var Result = await Cmd(Typst, [
    "eval", $"query({ManifestLabel}).first().value",
    "--in", ManifestPath, "--root", Root, "--pretty",
], Ct).Text(Ct);

var Manifest = JsonSerializer.Deserialize<ProjectManifest>(Result.Stdout, Json);
```

`Text(Ct)` 內部並行消費 stdout、stderr 並等待退出，回傳：

```cs
record CommandTextResult(
    string Stdout,
    string Stderr,
    CommandExit Exit);
```

`Cmd(...).Text(Ct)` 對非零退出仍丟例外；要自行判斷退出碼則：

```cs
var Result = await TryCmd(...).Text(Ct);
```

這樣腳本不用每次手寫三個 task，也不會漏讀 stderr 導致卡死。你確認的話我就加 decl/impl、測試，並改 `Mvn.csx`。
````
	]
	
	-T[2026_0817_194724][
給CsSh做一下代碼審查。看看還有沒有問題 或者應該有的但是缺的功能
	][
````md
審查結論：目前核心流程能用，但還有幾個實質問題；現有 24/24 測試通過不能覆蓋以下邊界。

高優先級問題：

1. 相對 `Find` 基本上會失效

[FileSystem.Impl.cs:120](E:\_code\Ngan\Tsinswreng.CsSh\proj\Tsinswreng.CsSh\FileSystem.Impl.cs:120) 到 126 以相對 glob 建 Regex，卻拿絕對的 `Entry.FullName` 匹配。

例如：

```cs
Cd("sample");
Find("input/**/*.txt");
```

Regex 是 `^input/...$`，實際路徑是 `E:/.../sample/input/...`，匹配不到。

而且 `GlobRoot` 第 271 行使用 `Environment.CurrentDirectory`，不是 `Sh.CurrentDirectory`；`Cd()` 只改了 Sh 內部目錄，兩者已經不一致。

2. `Cp`／`Mv` 不符合 Bash 的目的地語義

[FileSystem.Impl.cs:74](E:\_code\Ngan\Tsinswreng.CsSh\proj\Tsinswreng.CsSh\FileSystem.Impl.cs:74) 起，目的地如果是已存在的目錄，不會自动变成：

```text
destination/source-file
destination/source-directory
```

例如 Bash：

```bash
cp a.txt out/
mv a.txt out/
```

Cssh 目前會把 `out` 當成檔案路徑，最後報錯。

`cp -r src existing-dir/` 的 Bash 語義也沒有實現。

3. 所謂異步文件 API 有大量同步阻塞操作

以下 API 的異步版本仍直接做同步 I/O：

- `Exists`
- `Mkdir`
- `Rm`
- `Read`
- `Mv`

例如 [FileSystem.Impl.cs:166](E:\_code\Ngan\Tsinswreng.CsSh\proj\Tsinswreng.CsSh\FileSystem.Impl.cs:166) 的 `Read` 同步建立 `FileStream`；[FileSystem.Impl.cs:96](E:\_code\Ngan\Tsinswreng.CsSh\proj\Tsinswreng.CsSh\FileSystem.Impl.cs:96) 的 `Mv` 完全是同步 `File.Move`／`Directory.Move` 再包 `Task.CompletedTask`。

如果 API 宣稱「異步文件操作」，這個實現不符合承諾。

4. `Cp` 覆寫目錄有資料破壞風險

[FileSystem.Impl.cs:207](E:\_code\Ngan\Tsinswreng.CsSh\proj\Tsinswreng.CsSh\FileSystem.Impl.cs:207) 到 213：

```cs
if (Directory.Exists(Destination) && Overwrite)
    Directory.Delete(Destination, recursive: true);
```

覆寫目錄時先整棵刪除，再開始複製。若中途取消或複製失敗，原目的地已經消失。更符合 Bash 的做法應該是合併覆寫，而不是先刪整棵樹。

中優先級問題：

5. `Find`／`Ls` 用 `Task.Yield()` 偽造異步

[FileSystem.Impl.cs:138](E:\_code\Ngan\Tsinswreng.CsSh\FileSystem.Impl.cs:138) 和 158 每一項都 `await Task.Yield()`，但枚舉本身仍是同步文件系統枚舉。這只增加排程成本，沒有真正的異步 I/O。

6. `Command.DisposeAsync()` 對未啟動命令的資源處理不完整

[Command.Impl.cs:85](E:\_code\Ngan\Tsinswreng.CsSh\proj\Tsinswreng.CsSh\Command.Impl.cs:85) 到 89 只完成 Pipe 並取消 `Done`，沒有釋放 `Result.Stdout`／`Result.Stderr` 包裝的底層 Pipe Stream。

大量建立但未執行的 lazy `Command` 可能累積資源。

7. 取消命令時可能留下進程

[Command.Impl.cs:118](E:\_code\Ngan\Tsinswreng.CsSh\proj\Tsinswreng.CsSh\Command.Impl.cs:118) 到 122 使用取消 token 同時取消 `WaitForExitAsync` 和輸出複製；`TryKill()` 只發出 kill，但沒有明確等待進程真正退出。

需要驗證取消後是否一定沒有殘留子進程，尤其是 Windows 的 process tree 行為。

8. `Content.Text()` 沒有防止重複消費

Content 是一次性流，但 `Text()`、`Stream`、隱式 `string` 可以被多次調用。第二次只會讀到剩餘內容或空字串，API 沒有狀態提示，容易誤用。

9. raw command 字串模式能力有限但文件容易讓人誤解

`Cmd(string Command)` 只按第一個空白切割可執行檔，不解析 shell 語法。以下都不支援：

```text
管道 |
重定向 >
&&
環境變量展開
可執行檔路徑含空格
```

目前有 IList 版本可以解決參數轉義，但應在 API 文件中更醒目地區分「原始命令字串」與「參數列表」。

缺少的常用功能：

- 每個命令專用的環境變量設定／移除，而不是只能修改整個進程環境。
- `Cp`／`Mv` 的 Bash 目的地規則。
- `Find` 的排除模式、隱藏文件選項、符號鏈接策略。
- 文件屬性／時間／大小的明確異步 API。
- 命令超時。
- 取消後可取得「被取消」而不是普通失敗的結構化狀態。
- 將 stdout、stderr 合併成單一流的明確 API。
- 不依賴改變當前目錄的工作區／命令 scope；目前 `Cd` 是 Sh 實例狀態，但部分文件系統 glob 邏輯仍看進程 cwd。

最值得先修的順序是：

1. 修正 `Find` 相對路徑與 `Cd` 狀態不一致。
2. 修正 `Cp`／`Mv` 目的地語義。
3. 決定文件 API 是否真的要異步；若要，就不能用同步 I/O 包 `Task`。
4. 補取消、Dispose、未啟動 Command 的測試。
5. 再補環境變量與命令超時。
````
	]
	
	-T[2026_0817_194756][
		幾個問題。
		+ #[你的Find目前是完全用glob實現的嗎? 如果是那是不是應該直接叫作glob?]
		+ #[你是說不同Sh實例能有各自獨立的環境變量嗎?]
		+ #[`Cmd(string 完整命令)`既然你說不好那就刪了吧。
			你說他不支持重定向和管道, 難道用 參數數組的寫法的就支持了嗎?
			
		]
		+ #[Content.Text()重複消費這個, 第一次消費的時候給他緩存到成員變量上,
			調用時先查緩存 這樣行不行?
		]
		+ #[Mv,Cp 的問題 我沒看懂。]
	][
````md
你這幾點判斷如下。

### `Find` 是否應改名 `Glob`

是。

目前實作本質是：

```text
遞迴枚舉文件系統
+ 用 glob pattern 過濾
```

它不是 Bash 的 `find` 語義，也不支持 predicate、`-type`、`-size`、`-exec` 等條件。

所以更準確應該叫：

```cs
Glob("src/**/*.cs", Ct)
```

`Find` 這個名字可以留給未來真正的條件搜索 API。

另外目前相對路徑還有 bug：

```cs
Cd("project");
Glob("src/**/*.cs");
```

應該相對於 `Sh` 的當前目錄匹配，而不是相對進程 `Environment.CurrentDirectory`。改名時應一起修正。

### 不同 `Sh` 實例是否有獨立環境變量

目前沒有。我之前那樣說是不準確的。

現在：

```cs
Sh.SetEnv(...)
```

實際調用的是：

```cs
Environment.SetEnvironmentVariable(...)
```

所以是整個進程級別的環境變量，所有 `Sh` 實例共享。

如果要獨立，應該是：

```cs
var A = new Sh();
var B = new Sh();

A.SetEnv("X", "1");
B.SetEnv("X", "2");
```

兩個命令各自從自己的環境快照建立 `ProcessStartInfo.Environment`。

但這是另一種明確的設計；目前代碼並沒有這個能力。

### 刪除 `Cmd(string 完整命令)`

應該刪，而且不應只刪 `Cmd`。

因為：

```cs
Cmd("git status --short")
```

這種 raw command 字串有解析限制；而：

```cs
Cmd("git", ["status", "--short"])
```

只解決「可執行檔與參數如何分隔」，不會支持：

```text
|
>
>>
<
&&
環境變量展開
```

也就是說，參數列表不是 shell。

管道應使用 Cssh 的流：

```cs
var A = Cmd("git", ["log"], Ct);
var B = Cmd("grep", ["release"], new(A.Result.Stdout), Ct);
```

重定向應使用：

```cs
await Cmd("dotnet", ["build"], Ct).Out("build.log", Ct);
```

因此我建議整套刪除：

```cs
Cmd(string)
TryCmd(string)
Exe(string)
TryExe(string)
Q(string)
```

只保留：

```cs
Cmd(string Exe, IList<string> Args, ...)
TryCmd(string Exe, IList<string> Args, ...)
Exe(string Exe, IList<string> Args, ...)
TryExe(string Exe, IList<string> Args, ...)
```

然後把現有腳本全部改成參數列表。

### `Content.Text()` 緩存是否可行

可行，而且應該做。

但不能只是簡單加一個 `string` 字段，因為同步和異步同時調用時可能重複消費流。比較正確的是共用一個緩存任務：

```cs
private Task<string>? TextTask;
```

第一次調用時真正消費底層流；後續：

```cs
await Content.Text(Ct);
Content.Text();
(string)Content;
```

都返回同一份文字。

需要注意：

- 只緩存 `Text()` 的結果；
- 如果呼叫方先直接消費 `Content.Stream`，之後再 `Text()`，已經消費掉的內容無法恢復；
- `Content` 本身仍然是一次性流，不能把任意 Stream 消費都自動倒帶；
- 同步／異步並發調用必須共用同一個讀取任務。

### `Cp`／`Mv` 的問題

問題在 Bash 中「目的地是已存在目錄」時，會自動把源文件名或目錄名接到目的地後面。

例如：

```bash
mkdir out
cp a.txt out/
```

結果是：

```text
out/a.txt
```

但目前 Cssh：

```cs
Cp("a.txt", "out", Ct);
```

會把 `out` 當成完整文件路徑，而不是自動變成 `out/a.txt`。

目錄也是：

```bash
mkdir out
cp -r src out/
```

結果：

```text
out/src/...
```

目前實作若 `out` 已存在，通常會直接報「目標目錄已存在」；若 `out` 不存在，則會把 `src` 的內容直接複製成 `out` 的內容，不是 `out/src`。

`Mv` 有同樣問題：

```bash
mv a.txt out/
```

應得到：

```text
out/a.txt
```

目前則可能嘗試直接把文件移動到名為 `out` 的路徑。

另外目前 glob 複製還有一個額外問題：

```cs
Cp("src/*", "out", new(Overwrite: false), Ct);
```

匹配到的文件在 `CopyMatches` 裏實際上固定用 `Overwrite: true`，會忽略呼叫方傳入的選項。

所以 `Cp/Mv` 需要補的是 Bash 的目的地語義，不是單純加一個參數。
````
	]
	
	-T[2026_0817_195553][
		Q留着不刪。
		
		不同Sh實例 不同環境變量 能不能實現?
		是否容易實現?
	][
````md
可以，而且不算難；`.NET ProcessStartInfo` 原生支持每個子進程獨立的 `Environment` 字典。

建議語義：

```cs
var A = new Sh();
var B = new Sh();

A.SetEnv("MODE", "debug");
B.SetEnv("MODE", "release");

var AResult = await A.Exe("tool", [], Ct);
var BResult = await B.Exe("tool", [], Ct);
```

兩個命令分別收到不同的 `MODE`，且不修改主進程環境，也不互相影響。

實現方式：

1. `Sh` 不再調用 `Environment.SetEnvironmentVariable`。
2. 每個 `Sh` 保存自己的環境覆寫／刪除設定。
3. `GetEnv`、`SetEnv`、`UnsetEnv` 都只操作該實例。
4. 建立 `Cmd` 時，把「當前進程環境 + 該 Sh 的覆寫」快照存入 `CommandRunOptions`。
5. `ProcessStartInfo` 啟動時套用這份快照。

需要特別定義一點：環境在建立 `Cmd` 時快照。

```cs
A.SetEnv("X", "before");
var Cmd = A.Cmd("tool", [], Ct);

A.SetEnv("X", "after");
await Cmd;
```

命令仍使用 `before`。這和目前 `Cwd` 在建立命令時快照的行為一致，也避免 lazy command 因後續狀態變化而不可預期。

成本主要是：

- `CommandRunOptions` 增加環境快照字段；
- `Sh` 增加實例級環境狀態；
- `GetEnv`／`SetEnv`／`UnsetEnv` 改為操作實例；
- `ProcessStartInfo` 套用快照；
- 補兩個 `Sh` 實例互不干擾的測試。

所以結論是：容易實現，且比目前進程全局環境變量的設計更合理。Q 保留不動。
````
	]
	
	-T[2026_0817_195747][
		你這個是改子命令進程的環境變量是吧?
		那這語義不就亂套了?
		子進程的環境變量應該是在Cmd/Exe的參數裏面改纔對吧?
	][
````md
對，你說得對。我前面的「每個 `Sh` 實例保存自己的環境」把兩種語義混在一起了，不應該那樣設計。

正確分層應該是：

### 腳本自身的環境

```cs
Environment.GetEnvironmentVariable(...)
Environment.SetEnvironmentVariable(...)
```

這是當前 `.csx`／宿主進程的環境，天然是進程級共享，不屬於某個 `Sh` 實例。

### 子命令的環境

應放在 `Cmd`／`Exe` 的選項 DTO 中，例如：

```cs
public sealed record CommandOptions(
    Content? Input = null,
    str? Cwd = null,
    IReadOnlyDictionary<str, str?>? Env = null);
```

使用：

```cs
var Options = new CommandOptions(
    Env: new Dictionary<string, string?> {
        ["MODE"] = "debug",
        ["TEMP_VALUE"] = null, // 從繼承環境中移除
    });

await Exe("tool", [], Options, Ct);
```

語義是：

- 子進程先繼承父進程環境；
- `Env` 中的值覆蓋它；
- 值為 `null` 時移除該變量；
- 在建立 `Cmd`／呼叫 `Exe` 時快照；
- 不修改宿主進程環境；
- 不同命令可以各自擁有不同環境。

所以：

- `Sh.SetEnv`：只代表修改腳本自身進程環境；
- `CommandOptions.Env`：代表修改某一個子命令環境；
- 不應該把「不同 `Sh` 實例有不同子進程環境」作為設計。

這樣語義才不會混亂。
````
	]
	
	-T[2026_0817_195952][
		那你總結一下
		現在總共哪些要改的
	][
````md
目前確定要改的有這些：

1. `Find` 改名為 `Glob`

   - 因為現在實作是「遞迴枚舉 + glob 過濾」。
   - 修正相對路徑，必須依照 `Sh` 自己的 `Cd` 狀態，而不是 `Environment.CurrentDirectory`。
   - 同步更新 `ShGlobal`、腳本、測試與註釋。

2. 刪除完整命令字串重載

   刪除：

   ```cs
   Cmd(string Command, ...)
   TryCmd(string Command, ...)
   Exe(string Command, ...)
   TryExe(string Command, ...)
   ```

   只保留：

   ```cs
   Cmd(string Exe, IList<string> Args, ...)
   TryCmd(string Exe, IList<string> Args, ...)
   Exe(string Exe, IList<string> Args, ...)
   TryExe(string Exe, IList<string> Args, ...)
   ```

   `Q(string)` 保留，不刪。

   參數列表只負責參數分隔，不支持管道、重定向、`&&` 等 shell 語法；管道和重定向使用 Cssh 的 Stream／`Out` API。

3. 子命令環境變量放進 `CommandOptions`

   不做「每個 `Sh` 實例一套環境」的設計。

   保留：

   ```cs
   SetEnv(...)
   GetEnv(...)
   UnsetEnv(...)
   ```

   它們修改當前腳本進程環境。

   新增：

   ```cs
   CommandOptions.Env
   ```

   只影響該個 `Cmd`／`Exe` 建立的子進程：

   - 先繼承父進程環境；
   - `Env` 中的值覆蓋；
   - `null` 表示移除；
   - 在建立命令時快照。

4. `Content.Text()` 增加緩存

   - 第一次同步或異步 `Text` 消費底層 Stream；
   - 結果緩存到共享的 `Task<string>`；
   - 後續 `Text()`、`Text(Ct)`、隱式轉 `string` 共用同一結果；
   - 直接操作 `Content.Stream` 仍然是一次性消費，無法事後恢復。

5. 修正 `Cp`／`Mv` 的 Bash 目的地語義

   例如：

   ```cs
   Cp("a.txt", "out", Ct);
   ```

   如果 `out` 已存在且是目錄，結果應是：

   ```text
   out/a.txt
   ```

   目錄複製也要處理：

   ```cs
   Cp("src", "out", Ct);
   ```

   如果 `out` 已存在，結果應是：

   ```text
   out/src/...
   ```

   另外修正：

   - glob 複製不能無視 `Overwrite`；
   - 覆寫目錄不應先整棵刪除再複製；
   - `Mv` 同樣遵循已存在目錄的目的地規則。

6. 重新檢查異步文件 API

   目前 `Mv`、`Read`、`Exists`、`Mkdir`、`Rm` 的異步版本仍有同步 I/O。需要決定並統一：

   - 要麼改成真正的異步實作；
   - 要麼不要宣稱它們是完全異步。

另外，命令取消、未啟動 `Command` 的釋放、進程是否確實被殺掉，屬於審查發現的後續風險，應補測試，但不改變上面的 API 方向。
````
	]
	
	-T[2026_0818_121501][
		bash的if有很多功能、比如if -f , if -d 等 判斷是文件還是文件夾 之類的。你看看目前用cssh是否已有對應的, 如果沒有 那看看有哪些是應該加的。
	][
````md
結論：目前 CsSh 只有 `Exists` 是直接對應 Bash `test -e/-a` 的 API。文件／文件夾類型目前要靠 `Ls`/`Glob` 返回的 `FileSystemInfo` 判斷，寫成 `Entry is FileInfo`，對單一路徑不夠方便。

現有 API：

| Bash 判斷 | CsSh 現況 | 評價 |
|---|---|---|
| `-e path` / `-a path` | `Exists(path)` | 已有 |
| `-f path` | `Ls/Glob` 後判斷 `FileInfo` | 應補直接 API |
| `-d path` | `Ls/Glob` 後判斷 `DirectoryInfo` | 應補直接 API |
| `-s path` | `FileInfo.Length > 0` | 可由 BCL 完成，暫不必另包 |
| `-h` / `-L` | `FileAttributes.ReparsePoint` 可間接判斷 | 應補，但要明確是 link/reparse point |
| `-r` | 無 | 不建議直接加，跨平台且 ACL 語義不穩定 |
| `-w` | 無 | 同上 |
| `-x` | 無 | Unix 執行位與 Windows 可執行文件不是同一語義，不應硬抄 |
| `-b/-c/-p/-S` | 無 | 平台特定，不屬於 CsSh 核心 |
| `-g/-k/-u` | 無 | Unix 權限位，Windows 無等價物 |
| `-O/-G` | 無 | 所有者語義跨平台差異大 |
| `-N` | 無 | 需要定義「上次讀取時間」語義 |
| `file1 -nt file2` / `-ot` | 無 | 可用 `LastWriteTimeUtc` 比較，但目前沒有便捷 API |
| `file1 -ef file2` | 無 | inode／文件身份跨平台實現較麻煩 |

我建議新增的最小核心 API 是：

```cs
bool IsFile(str Path);
Task<bool> IsFile(str Path, CT Ct);

bool IsDir(str Path);
Task<bool> IsDir(str Path, CT Ct);

bool IsLink(str Path);
Task<bool> IsLink(str Path, CT Ct);
```

使用時就能直接寫：

```cs
if (IsFile(Input)) {
	...
}

if (IsDir(Output)) {
	...
}
```

其中：

- `IsFile` 對應 Bash `-f`
- `IsDir` 對應 Bash `-d`
- `IsLink` 對應 Bash `-L`，但需要明確文檔定義是「符號鏈接」還是更廣義的 `.NET ReparsePoint`

另外可以補一個不造新 DTO 的查詢 API：

```cs
FileSystemInfo? Info(str Path);
Task<FileSystemInfo?> Info(str Path, CT Ct);
```

它直接返回現有 BCL 的 `FileInfo` 或 `DirectoryInfo`，讓腳本取得：

```cs
var Info = Info(Path);

if (Info is FileInfo File) {
	var Size = File.Length;
	var ReadOnly = File.IsReadOnly;
}

if (Info is DirectoryInfo Dir) {
	var Modified = Dir.LastWriteTimeUtc;
}
```

這樣不用另外定義 CsSh 自己的文件屬性類型。

不建議現在新增 `IsReadable`、`IsWritable`、`IsExecutable`：`.NET` 在 Windows、Unix 上的權限模型不同，做出一個看似 Bash 等價但實際不可靠的 API 反而會造成誤判。

還有兩個現有整理問題：

- 測試類仍叫 `TestLsAndFind`，但 API 已改名為 `Glob`。
- 部分註釋和 Sample 還寫 `Find`，應統一改成 `Glob`。

所以目前最值得補的是 `IsFile`、`IsDir`、`IsLink`，以及可選的 `Info`；其餘 Bash `test` 旗標不應全部照搬。
````
	]
	
	-T[2026_0818_122200][
		只給一個Info 是不是在功能上就已經夠了
	][
````md
是，作为底层能力，一个 `Info` 基本够了，而且比堆 `IsFile`、`IsDir` 更统一。

建议：

```cs
FileSystemInfo? Info(str Path);
Task<FileSystemInfo?> Info(str Path, CT Ct);
```

用法：

```cs
var Entry = Info(Path);

if (Entry is FileInfo File) {
	// -f
	var IsEmpty = File.Length == 0; // -s
}

if (Entry is DirectoryInfo) {
	// -d
}

if (Entry?.Attributes.HasFlag(FileAttributes.ReparsePoint) == true) {
	// -L / link
}
```

语义应定义为：

- 路径不存在：返回 `null`
- 文件：返回 `FileInfo`
- 文件夹：返回 `DirectoryInfo`
- 其他属性直接使用 .NET 的 `Attributes`、`Length`、时间等
- 不负责模拟 Unix 专属的 `-r`、`-w`、`-x`、设备文件判断

这样 `Info` 已经覆盖主要的 `-e`、`-f`、`-d`、`-s`、`-h` 功能。`Exists` 可以保留作为最简便的布尔判断；`IsFile`、`IsDir` 暂时没必要新增。
````
	]
	
	-T[2026_0818_122652][
		Info叫FsInfo吧。
		你去實現一下。
		測試也寫了。
	][
		
	]
	
	-T[2026_0818_193923][
		有個事。
		你看看`E:\_code\Ngan\Tsinswreng.Cssh\proj\Tsinswreng.Cssh\Path.cs`
		是不是加一下這個比較好?
		這樣方便掛一些成員/擴展,
		如果直接掛到string上容易污染。
		
		然後實際寫腳本的時候IsDir IsFile
		還是比較常用的 只用FsInfo代碼量大 用着不方便。
		是不是加回來比較好? 如果要加那應該加在哪裏?
	][
````md
應該加回 `IsFile`、`IsDir`；`FsInfo` 留作需要大小、時間、屬性時的完整入口。

但它們不應掛在目前這個 `Path` 值類型上。

現有 `Path` 只保存字符串；而相對路徑的含義取決於某個 `Sh` 實例的 `Cd`。例如：

```cs
var Sh1 = new Sh();
var Sh2 = new Sh();
Sh1.Cd("a");
Sh2.Cd("b");

Path P = "item";
```

`P.IsFile()` 無法知道該按 `a/item` 還是 `b/item` 判斷。若偷偷固定用 `ShGlobal`，對自建 `Sh` 實例就是錯的語義。

建議分工：

```cs
public partial class Sh {
	public partial bool IsFile(str Path);
	public partial Task<bool> IsFile(str Path, CT Ct);

	public partial bool IsDir(str Path);
	public partial Task<bool> IsDir(str Path, CT Ct);

	public partial FileSystemInfo? FsInfo(str Path);
	public partial Task<FileSystemInfo?> FsInfo(str Path, CT Ct);
}
```

`ShGlobal` 照樣轉發，因此腳本很短：

```cs
using static Tsinswreng.CsSh.ShGlobal;

if (IsFile("settings.json")) {
	...
}

if (IsDir("ExternalRsrc")) {
	...
}
```

`Path` 則只做無上下文的「路徑值／路徑組合／名稱與副檔名」成員，避免污染 `string`。這個方向是對的。

不過目前 [Path.cs](E:/_code/Ngan/Tsinswreng.CsSh/proj/Tsinswreng.CsSh/Path.cs) 有兩個相同簽名的 `operator /(Path, string)`，而且都未實現；這必然不能編譯。先要定下 `Path` 的定位：

- 建議：`readonly record struct Path(string Value)`，只負責 path value。
- 不建議：讓它偷偷依賴 `ShGlobal` 執行文件系統查詢。

你確認這個分工後，我就把 `Path` 補完整，並加 `Sh.IsFile`／`Sh.IsDir`、全局轉發與測試。
````
	]
	
	
	-T[2026_0818_195626][
		那就按你說的做。
		其他的API 本身是路徑但聲明成了string的你也改成path。
		現在去做。
	][
		
	]
	
	-T[2026_0818_213058][
		是不是應該加一個 BaseName, DirName, RealPath?
		名字怎麼取?
		舉一下對應C\# 自帶API的寫法
		
	][
		
	]
	
	-T[2026_0818_225613][
		解釋一下 Cmd, TryCmd, Exe, TryExe 區別
	][
		
	]
	
	
]

