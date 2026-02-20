#H[AI生成RespLlmDict結構YamlMd格式字符串提示詞][
	#H[核心要求][
		1. 生成的最終內容必須嚴格遵循*YamlMd*格式規範（參考CsYamlMd說明書）
		2. RespLlmDict結構的所有多行文本字段內容，必須放置在Markdown的代碼塊中
		3. Yaml部分通過錨點（*__xxx）引用Markdown代碼塊內容，無需額外縮進與轉義
		4. 輸出完整的YamlMd格式字符串，可直接解析爲合法的Yaml結構
	]

	#H[YamlMd格式約束][
		- Yaml根節點需對應RespLlmDict的結構字段（如operations、text等），每個字段值爲對應的Markdown錨點引用
		- Markdown部分以一級標題（\# __xxx）定義錨點名稱，標題後緊跟代碼塊
		- 代碼塊必須使用5個反引號（``````）作爲分隔符，避免內容中的反引號導致格式中斷
		- 空內容場景處理規則：
		  - 標題後無代碼塊：對應Yaml錨點值設爲null
		  - 標題後有代碼塊但內容爲空：對應Yaml錨點值設爲空字符串
	]

	#H[格式示例][
		```yaml
		operations: *__operations
		text: *__text
		```

		# __operations
		``````ts
		// RespLlmDict的operations字段對應的多行文本內容
		const operations = [
			{
				type: "replaceByLine",
				path: "E:/example/file.ts",
				replace: [{ startLine: 1, endLine: 5, data: { baseIndent: "", content: "*__content1" } }]
			}
		];
		``````

		# __text
		``````
		// RespLlmDict的text字段對應的多行文本內容
		已完成指定文件的代碼替換操作，嚴格遵循YamlMd格式規範。
		``````
	]

	#H[語法細節][
		- Yaml部分縮進統一使用2個空格，保證Yaml解析合法性
		- Markdown代碼塊內的文本保持原始格式，不額外添加縮進或轉義字符
		- Yaml錨點名稱（如__operations）必須與Markdown一級標題名完全一致
		- 路徑字段需使用絕對路徑，並以正斜槓（/）作爲分隔符
	]
]
	#H[核心要求][
		1. 生成的最終內容必須嚴格遵循*YamlMd*格式規範（參考CsYamlMd說明書）
		2. RespLlmDict結構的所有多行文本字段內容，必須放置在Markdown的代碼塊中
		3. Yaml部分通過錨點（*__xxx）引用Markdown代碼塊內容，無需額外縮進與轉義
		4. 輸出完整的YamlMd格式字符串，可直接解析爲合法的Yaml結構
	]

	#H[YamlMd格式約束][
		- Yaml根節點需對應RespLlmDict的結構字段（如operations、text等），每個字段值爲對應的Markdown錨點引用
		- Markdown部分以一級標題（\# __xxx）定義錨點名稱，標題後緊跟代碼塊
		- 代碼塊必須使用5個反引號（``````）作爲分隔符，避免內容中的反引號導致格式中斷
		- 空內容場景處理規則：
		  - 標題後無代碼塊：對應Yaml錨點值設爲null
		  - 標題後有代碼塊但內容爲空：對應Yaml錨點值設爲空字符串
	]

	#H[格式示例][
		```yaml
		operations: *__operations
		text: *__text
		```

		# __operations
		``````ts
		// RespLlmDict的operations字段對應的多行文本內容
		const operations = [
			{
				type: "replaceByLine",
				path: "E:/example/file.ts",
				replace: [{ startLine: 1, endLine: 5, data: { baseIndent: "", content: "*__content1" } }]
			}
		];
		``````

		# __text
		``````
		// RespLlmDict的text字段對應的多行文本內容
		已完成指定文件的代碼替換操作，嚴格遵循YamlMd格式規範。
		``````
	]

	#H[語法細節][
		- Yaml部分縮進統一使用2個空格，保證Yaml解析合法性
		- Markdown代碼塊內的文本保持原始格式，不額外添加縮進或轉義字符
		- Yaml錨點名稱（如__operations）必須與Markdown一級標題名完全一致
		- 路徑字段需使用絕對路徑，並以正斜槓（/）作爲分隔符
	]
]