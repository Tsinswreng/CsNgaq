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

#H[E:\_code\CsNgaq\Ngaq.Test\proj\Ngaq.Backend.Test\Domains\Word\SvcWordV2\TestISvcWordV2.BatAddNewWordToLearn.cs][
	補測試用例。
	
]

#H[完善RecentUse][
	[2026_0407_210646,]
	
]

#H[下拉框選項也要i18n][
	[2026_0407_212317,]
]

#H[llm 詞典 解析失敗處理][
	[2026_0408_180000,]
	SvcDict 拋異常 LlmResponseParseFailed 時、
	前端丟失 已得之 流式數據
]

#H[Gtts 請求失敗時應拋出指定異常][
	[2026_0409_143753,]
]



#H[Repo.BatGetAggById 測試關聯的實體也不能有被軟刪的][
	[2026_0409_203019,]
]


#H[優化大模型詞典 用戶提示詞處理][
	[2026_0411_160324,]
```
File: e:\_code\CsNgaq\Ngaq.Backend\Domains\Dictionary\Svc\SvcDictionary.cs
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

#H[ViewNormLangToUserLangPage][
	[2026_0425_113205,]
	`E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Word\WordManage\NormLangToUserLang\NormLangToUserLangPage\ViewNormLangToUserLangPage.cs`
	
	這裏的表格 不用顯示 標準語言類型 和 描述。
	
	`E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Word\WordManage\NormLangToUserLang\NormLangToUserLangEdit\VmNormLangToUserLangEdit.cs`
	這裏纔要顯示 標準語言類型。
	然後 VmNormLangToUserLangEdit 的 選擇按鈕 的 圖標 改成 `E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Icons\Svgs.Decl.cs` 的 ListSelect
	
]

#H[統計圖 應顯示年份][
	[2026_0413_221853,]
	`E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Word\WordManage\Statistics\ViewStatistics.cs`
	下方橫坐標軸  顯示的格式是 `04-26`這樣的、豎着的
	假如我統計的時間跨度超過一年 看座標軸就不知道是哪一年的。
	且 橫坐標軸 標籤 和 橫坐標軸線 相交了、容易看不清楚。
	
	再把這裏的默認分頁大小改成10。原先20太大了。只改這裏的。
]


#H[從llm dict進入語言選擇頁 無法添加][
	[2026_0414_105711,]
	`E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Dictionary\ViewDictionary.cs`
	進入
	
	`E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Word\WordManage\NormLang\NormLangPage\ViewNormLangPage.cs`
	本來 ViewNormLangPage是有添加按鈕的。 如果是從 ViewDictionary 進入 ViewNormLangPage的話、 ViewNormLangPage 的添加按鈕就不見了。應該要有。
	
	此外、 
	`E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Word\WordManage\NormLang\NormLangEdit\ViewNormLangEdit.cs` 要顯示 語言類型 如 Bcp47
]

#H[UserLangToNormLang 配置界面 不能選擇NormLang 必須手動輸入][
	[2026_0414_105753,]
	`E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Word\WordManage\UserLang\UserLangEdit\ViewUserLangEdit.cs`
	
	關聯語言 輸入框 後面加一個選擇按鈕、點擊之後 轉到 
	`E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Word\WordManage\NormLang\NormLangPage\ViewNormLangPage.cs`
	的頁面、點擊其中一項就能選擇
	
	然後這個 ViewUserLangEdit 頁面 還要顯示 關聯語言類型。
]


#H[View/NormLangToUserLangPage/ModifiedTime
not found][
	[2026_0416_224448,]
]


#H[詞典 大模型 提示詞 強調 用戶輸入拼寫不正確時要在Head糾正][
	[2026_0420_101710,]
	`E:\_code\CsNgaq\Ngaq.Backend\Domains\Dictionary\Prompt\Prompt.typ`
	強調 Head字段 是 規範化後的詞頭
	假如用戶輸入了 dictioary、那返回的Head字段應該是 dictionary
]


#H[統計頁面 學習結果 要I18n][
	[2026_0421_111530,]
	E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Word\WordManage\Statistics\ViewStatistics.cs
	Add/Fgt/Rmb 這幾樣 在下拉框裏。
	先標上Todo.I18n先
]


#H[備份同步頁 操作成功後要有Toast提示][
	[2026_0421_200917]
]

#H[優化 GlobalErrHandler 異常處理][
	[2026_0421_201226,]
	`E:\_code\CsNgaq\Ngaq.Server\proj\Ngaq.Server.Http\GlobalErrHandler.cs`
	- 要注入Logger輸入異常信息
]


#H[快捷鍵查詞][
	[2026_0421_212925,]
	目前差linux版
]



#H[跨平臺 音頻播放][
	[2026_0422_094904,]
	目前差linux版
]


#H[單詞添加頁][
	[2026_0423_222156,]
	- 增 格式說明
	- 用 文本編輯器控件
	- 刪 他ʹ 功能、只留 文本添加

E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Word\WordManage\AddWord\ViewAddWord.cs
]

#H[js 權重算法自定義 增 文檔][
	[2026_0423_222328,]
	或統一作進階文檔
]

#H[多增內置js權重算法與參數][
	[2026_0423_222256,]
]

#H[NormLangPage 本土名稱列 放後面][
	[2026_0423_222433,]
	
	E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Word\WordManage\NormLang\NormLangPage\ViewNormLangPage.cs
]


#H[單詞編輯頁 之 刪除時間 宜譯爲 軟刪除時間][
	[2026_0425_111148,]
	控件用 TempusBox 勿直ᵈ顯 unixMs
	
	E:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Views\Word\WordEditV2\ViewWordEditV2.cs
]

#H[ItblToStream 不應用 MemoryStream][
	[2026_0425_114358,]
	`E:\_code\CsNgaq\Tsinswreng.CsTools\proj\Tsinswreng.CsTools\ItblToStream.cs`
]
