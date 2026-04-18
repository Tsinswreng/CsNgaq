#let H(title, doc)=[]
=
[2025-06-07T21:48:15.427+08:00_W23-6]
+ 測試權重數值溢出

=
[2025-06-07T10:02:56.835+08:00_W23-6]
+ 用觸發器自動更新InsertAt及UpdateAt
+ 權重算法日誌

=
[2025-09-24T20:00:49.905+08:00_W39-3]
+ 相關API 如單詞導入導入 作命令行

=
[2025-10-01T22:26:50.629+08:00_W40-3]
+ FTS5全文檢索

=
[2025-10-16T10:05:39.052+08:00_W42-4]
i18n增退路鏈

#H[][
	SvcTokenStorage.SetRefreshToken中
```cs
new PoKv{
	Owner = IdUser.Zero,
}.SetStrStr(KeysClientKv.RefreshToken, Req.RefreshToken)
```
此處宜傳 實ʹ用戶ID
]


#H[][
	前端增一接口曰 UserInfoGetter(IdUser)
]


#H[2025-11-01T15:15:12.772+08:00_W44-6][
	#H[分頁對象包裝成流][

	]
]


#H[2025-11-02T16:31:36.236+08:00_W44-7][
	#H[][
		優化 詞庫同步
		增量同步, 流式, 分段, 進度條, 二進制序列化 ...
	]
	#H[][
		全量同步旹 處理既刪ʹ詞
		[,2025-11-08T22:29:06.915+08:00_W45-6]
	]
]

#H[2025-11-07T09:51:34.798+08:00_W45-5][
	潙PG等製 統一批量查詢寫法 減 數據庫往返
]


#H[2025-11-15T22:41:02.610+08:00_W46-6][
- 按需ᵈ示 詞ʹ 他ʹprop 如 annotation, summary 等
- 導入導入文件旹用文件選擇器API
]


#H[2025-11-26T11:18:16.919+08:00_W48-3][
切換新單詞旹緟置WordInfo之滾動條
移動端 滾動視圖 效果不甚佳、滾動條無法顯
]


#H[2025-12-01T22:18:07.052+08:00_W49-1][
慮ᵣ況芝從文本添新詞旹 若已有ʹ詞(詞頭,語言 同者)ˋ既被刪

使PoWord歸潙未刪、使舊ʹ資產標潙軟刪後 加入新詞
]


#H[2025-12-02T20:55:04.558+08:00_W49-2][
單詞同步頁 快速雙擊兩次Push(觸發後立即取消)則報錯

System.InvalidOperationException: This SqliteTransaction has completed; it is no longer usable
]

#H[2025-12-04T10:19:51.845+08:00_W49-4][
	Svg圖標 有厎上下顛倒
]

#H[2025-12-04T17:57:46.832+08:00_W49-4][
	ScrollViewer 內 套 SelectableTextBox 則 于觸屏端 前者失效。滑動旹變潙選擇文本
]

#H[2025-12-06T19:46:41.752+08:00_W49-6][
權重算法報錯旹 無日誌亦未呈于界面、唯斷點調試模式ʸ可知
]



#H[2026_0324_231201][
WinGlobalKey AOT下啓動後 無法顯程序主界面
]

#H[E:\_code\CsNgaq\Ngaq.Test\proj\Ngaq.Local.Test\Domains\Word\SvcWordV2\TestISvcWordV2.BatAddNewWordToLearn.cs][
	補測試用例。
	
]




#H[完善RecentUse][
	[2026_0407_210646,]
	
]

#H[下拉框選項也要i18n][
	[2026_0407_212317,]
]


#H[viewWordEditV2 無法刪除單詞(可能是API未實現)][
	[2026_0407_222106,]
]

#H[llm 詞典 解析失敗處理][
	[2026_0408_180000,]
	SvcDict 拋異常 LlmResponseParseFailed 時、
	前端丟失 已得之 流式數據
]

#H[Gtts 請求失敗時應拋出指定異常][
	[2026_0409_143753,]
]

#H[從llm詞典保存生詞 點save後無效][
	[2026_0409_143920,]
]

#H[PreFilter 分頁表 應顯示詳情][
	[2026_0409_150231,]
	如 core filter中只設了一項Field和FilterItem時(如Lang=italian)
	在外層表格行中顯示 Lang=italian
]

#H[學習方案管理頁面入口放到 背單詞頁面 settings下][
	[2026_0409_151340,]
]


#H[Repo.BatGetAggById 測試關聯的實體也不能有被軟刪的][
	[2026_0409_203019,]
]


#H[優化大模型詞典 用戶提示詞處理][
	[2026_0411_160324,]
```
File: e:\_code\CsNgaq\Ngaq.Local\Domains\Dictionary\Svc\SvcDictionary.cs
150: 		var userPrompt = BuildUserPrompt(Req);

```
]

#H[配置文件改用Yaml][
	[2026_0413_111035,]
	
]

#H[llm dict 支持自定義提示詞][
	[2026_0413_111922,]
]


#H[JsonCfgAccessor][
	[2026_0413_111948,]
	改爲 增DictCfgAccessor 再增 文件讀寫適配 㕥解藕
]


#H[從詞典頁面進入之 配置語言映射頁 無 菜單][
	[2026_0413_220334,]
]


#H[統計圖 應顯示年份][
	[2026_0413_221853,]
]


#H[從llm dict進入語言選擇頁 無法添加][
	[2026_0414_105711,]
]

#H[UserLangToNormLang 配置界面 不能選擇NormLang 必須手動輸入][
	[2026_0414_105753,]
	在背單詞頁面點朗讀、若未配則現
]


#H[View/NormLangToUserLangPage/ModifiedTime
not found][
	[2026_0416_224448,]
]



#H[登錄註冊頁][
	[2026_0417_142554,]
	按鈕文字要居中 換成MainColor
	密碼用 密碼專用輸入框。
	
	區域都集中一點
	
	目前是這樣的: 以登錄頁面爲例:
	
	```
	登錄|註冊
	電子郵件:
	電子郵件輸入框
	密碼:
	密碼輸出框
	
	
	(大段空白)
	
	
	登錄按鈕
	```
	
	你改成
	
	
	```
	登錄|註冊
	
	(均等的空白)
	
	電子郵件:
	電子郵件輸入框
	密碼:
	密碼輸出框
	
	登錄按鈕
	
	(均等的空白)
	
	```

]

