#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

#H[測試規範][
	本文重點只講兩件事:
	- 怎麼新建測試
	- 怎麼註冊測試

	主程序入口變動很少, 除非你要調整整個測試啓動流程, 否則*不要*把 token 浪費在入口細節上。
]

#H[目的][
	讀完本文後, AI 應能自行完成以下工作:
	- 爲某個 service / dao / manager 新建一個測試類
	- 在測試類中新增多個測試用例
	- 把測試類註冊到對應的 TestMgr
	- 讓上層 TestMgr 正常收編該子模塊測試

	*不要*把啓動測試的 API 掛到 `ITestNode` 上。測試樹與測試執行器必須保持獨立。
]

#H[核心角色][
	- `ITester`: 一個測試類就實現一個 `ITester`
	- `ITestNode`: 只表示測試樹節點, *不*負責啓動執行
	- `ITestExecutor`: 負責執行測試樹
	- `DiEtTestMgr`: 負責收集並註冊測試類, 同時維護 DI 與測試樹

	分工要點:
	- 測試類負責*定義*測試用例
	- TestMgr 負責*註冊*測試類
	- Executor 負責*執行*測試
]

#H[新增一個測試類][
	新增測試時, 優先模仿現有文件:
	- `Ngaq.Test/proj/Ngaq.Local.Test/Domains/Word/TestDaoWord.cs`
	- `Ngaq.Test/proj/Ngaq.Local.Test/Domains/Word/TestISvcWord.cs`

	推薦步驟:
	1. 在對應模塊的測試目錄下新建 `TestXxx.cs`
	2. 讓類實現 `ITester`
	3. 在構造函數中注入被測依賴
	4. 實現 `RegisterTestsInto`
	5. 用 `MkFnRegisterTest` 批量註冊測試用例
]

#H[標準寫法][
	```cs
	public class TestXxx: ITester{
		private readonly XxxSvc Svc;
		public TestXxx(XxxSvc svc){
			Svc = svc;
		}

		public ITestNode RegisterTestsInto(ITestNode? Test){
			Test ??= new TestNode();
			var R = Test.MkFnRegisterTest(typeof(TestXxx), typeof(XxxSvc));

			R("Case_A", async(o)=>{
				// arrange / act / assert
				return NIL;
			});

			R("Case_B", async(o)=>{
				return NIL;
			});

			return Test;
		}
	}
	```

	這是新增測試類的首選模板。除非場景特殊, 否則不要自行發明另一套註冊方式。
]

#H[RegisterTestsInto 約定][
	`RegisterTestsInto` 中遵守以下約定:
	- 開頭先寫 `Test ??= new TestNode();`
	- 再用 `var R = Test.MkFnRegisterTest(typeof(測試類), typeof(被測類型));`
	- 之後每個 `R("用例名", async(o)=>{ ... })` 就是一個測試用例
	- 結尾返回 `Test`

	`MkFnRegisterTest` 已經幫你把以下信息綁好:
	- 測試類型 `TesterType`
	- 被測類型 `TesteeType`
	- 用例函數 `FnTest`

	所以新增用例時, 一般只需要關心:
	- 用例名
	- 測試邏輯
	- 是否拋異常
]

#H[怎麼寫單個測試用例][
	單個測試用例本質上是一個 `async(o)=>{...}`。

	約定:
	- 成功就 `return NIL;`
	- 失敗就直接 `throw`
	- `o` 是預留擴展參數, 不需要時可忽略

	示例:
	```cs
	R("Should_Create_Word", async(o)=>{
		var id = await Svc.Create(...);
		if(id == null){
			throw new Exception("id should not be null");
		}
		return NIL;
	});
	```

	執行器以*是否拋異常*判定成敗。
]

#H[用例命名][
	用例名應當滿足:
	- 在同一個測試類內易於辨認
	- 能看出測什麼行爲
	- 不要寫成含糊的 `Test1`, `Try`, `Temp`

	推薦命名:
	- `Should_Create_Word`
	- `Should_Query_By_Id`
	- `Fail_When_Input_Invalid`

	目前代碼中也存在時間戳式名字, 這種方式可用於臨時試驗; 但若是要長期保留的測試, 更推薦語義化名稱。
]

#H[怎麼把測試類註冊到 TestMgr][
	新增完測試類後, *還必須註冊* 到對應的 TestMgr, 否則不會被執行。

	參考:
	- `Ngaq.Test/proj/Ngaq.Local.Test/LocalTestMgr.cs`

	標準寫法:
	```cs
	public class LocalTestMgr: DiEtTestMgr{
		public static LocalTestMgr Inst = new();
		public override ITestNode RegisterTestsInto(ITestNode? Test){
			Test = this.TestNode;
			this.RegisterTester<TestISvcWord>();
			this.RegisterTester<TestDaoWord>();
			this.RegisterTester<TestNewFeature>();
			return Test;
		}
	}
	```

	規則:
	- 一個測試類對應一次 `RegisterTester<T>()`
	- 新增測試類後, 去最近的 TestMgr 補一行 `RegisterTester<你的測試類>()`
	- 不要在這裏手動 `new` 測試類, 讓 DI 建立實例
]

#H[怎麼收編子模塊測試][
	如果是更上層的 TestMgr, 不直接註冊每個測試類, 而是收編下級 TestMgr。

	參考:
	- `Ngaq.Test/proj/Ngaq.Windows.Test/WindowsTestMgr.cs`

	標準寫法:
	```cs
	public class WindowsTestMgr: DiEtTestMgr{
		public static WindowsTestMgr Inst = new();
		public override ITestNode RegisterTestsInto(ITestNode? Test){
			Test = this.TestNode;
			this.RegisterSubMgr(LocalTestMgr.Inst);
			return Test;
		}
	}
	```

	規則:
	- 同一層收編子模塊時, 用 `RegisterSubMgr(...)`
	- 同一層收編具體測試類時, 用 `RegisterTester<T>()`
	- 不要把兩種責任混寫得過於混亂
]

#H[執行入口只需知道一點][
	除非你在改測試框架本身, 否則只需知道最穩定的最終形式:
	```cs
	var mgr = WindowsTestMgr.Inst;
	SvcProvdr = mgr.InitSvc(SvcColct);
	ITestExecutor executor = new TreeTestExecutor();
	await executor.RunEtPrint(mgr.TestNode);
	```

	你只要記住:
	- 執行器是 `TreeTestExecutor`
	- 啓動執行的是 `ITestExecutor`
	- 傳入的是 `mgr.TestNode`
	- *不要*寫成把 `RunEtPrint()` 掛在 `ITestNode` 上
]

#H[AI 新增測試時的最小操作清單][
	如果你是 AI, 當用戶要求“爲某個類補測試”時, 按這個順序做:
	1. 找到對應模塊下最近的測試目錄
	2. 新建 `TestXxx.cs`, 實現 `ITester`
	3. 在 `RegisterTestsInto` 中用 `MkFnRegisterTest` 註冊用例
	4. 在最近的 `TestMgr` 補 `RegisterTester<TestXxx>()`
	5. 若該模塊尚未被上層收編, 再補 `RegisterSubMgr(...)`
	6. 不改主入口, 除非用戶明確要求
]

#H[禁止事項][
	- 不要把測試執行 API 掛到 `ITestNode`
	- 不要繞過 DI 手動拼裝本來就能注入的依賴
	- 不要新增測試類但忘記在 TestMgr 註冊
	- 不要重複註冊同一個 tester type
	- 不要給測試節點傳重複的自定義唯一名

	注意:
	當 `DiEtTestMgr.RegisterTester<T>()` 發現 tester type 或節點唯一名重複時, 會直接拋異常, 不會偷偷加入列表。
]

#H[一句話總結][
	新增測試的本質只有兩步:
	- 在 `TestXxx : ITester` 裏用 `MkFnRegisterTest` 定義用例
	- 在對應 `TestMgr` 裏用 `RegisterTester<TestXxx>()` 註冊它

	除此之外, 一般不要亂改。
]

