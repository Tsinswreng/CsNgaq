#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;
#H[序列化][
	#H[Json][
		- 依賴注入 `Ngaq.Core/Tools/Json/IJsonSerializer.cs` (優先)
		- 或用 `JSON.Parse()` 等(不優先考慮)

			#H[Json與`IDict<str, obj?>`互轉][
				在 Tsinswreng.CsTools下 有 ToolJson類
			]
	]
	#H[Srefl][
		//TODO
	]

]

#H[支持序列化和反序列化的對象][
	實現了 `Ngaq.Core.Infra.IF.IAppSerializable` 接口的 class
	纔能序列化和反序列化
]

#H[Json 與 `IDict<str, obj?>`互轉][
	用 Tsinswreng.CsTools 下之 ToolJson
]

#H[`IDict<str, obj?>` 操作 多級讀寫][
	用 用 Tsinswreng.CsTools 下之 ToolDict
]
