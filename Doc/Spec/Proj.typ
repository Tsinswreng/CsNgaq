#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;
#[項目說明]

背單詞軟件
- 技術棧 C\# .NET 10
- 客戶端 Avalonia
- 本地服務端 Sqlite
- Web服務端 Asp.net Core minimal API

*!項目所有程序集都採用AOT編譯。禁止一切不兼容AOT的代碼!*

#H[程序集][
	csproj即程序集。
	#H[Ngaq.Core][
		核心程序集
		- 要求平臺無關(包含Web)
		包含:
		- 通用的基礎設施
		- 實體類定義
			- 前後端通用DTO
		- 平臺無關基礎業務邏輯
		- 接口(interface) 等

		平臺無關的意思是 放在哪裏都能編譯運行。要考慮Web平臺
		所有不能在此程序集中 直接做 文件讀寫, 數據庫操作 等相關IO操作。也不推薦你這麼做、因爲這會破壞架構約定。

		一般的做法是、在此程序集中 定義接口、比如我要操作詞庫 就定義詞庫服務接口、然後在接口中聲明方法。後端程序集再實現接口、在實現的方法體中執行IO操作。

	]

	#H[Ngaq.Local][
		後端基礎程序集。
	]

	#H[Ngaq.Frontend][
		前端文件夾。Avalonia項目。不是一個單獨的程序集。

		其proj/下有多個程序集。
		#H[Ngaq.UI][
			此程序集同樣要求平臺無關。使用MVVM模式。
			- 包含UI, 交互邏輯 等
			- 此程序集引用 Ngaq.Core 程序集。
		]
		後續提到的特定平臺的程序集僅有以下職責:
			- 程序入口(有Main方法或頂層語句)
			- 依賴注入 ServiceCollection裝配
			- 平臺特定功能的方法實現
		一般不會有UI、交互邏輯等。
		#H[Ngaq.Windows][
			引用以下程序集:
			- Ngaq.UI
			- Ngaq.Local
			Windows入口。

		]
		#H[Ngaq.Android][
			引用以下程序集:
			- Ngaq.UI
			- Ngaq.Local
			Android入口。
		]
		後續還有其他平臺特定入口程序集、就不一一列舉了。
	]
]


Ngaq.Frontend/
Ngaq.Local/
Ngaq.Server/
Ngaq.Test/
