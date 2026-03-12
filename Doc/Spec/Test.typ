#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

#H[測試規範][
	
使用的測試框架: 自研的 `Tsinswreng.CsTest`
]

#H[新建測試參考寫法][
	
	定義成分部類的形式、每個分部文件只測一個函數
	
	分部類主文件不測任何函數 只裝配
	
	`_TestXxx.cs`
	
	```cs
	using Tsinswreng.CsTest;
	public partial class TestXxx: ITester{
		XxxSvc Svc;
		public TestXxx(XxxSvc svc){
			Svc = svc;
		}
		public ITestNode RegisterTestsInto(ITestNode? Test){
			Test ??= new TestNode();
			var register = Test.MkTestFnRegister(typeof(TestXxx), typeof(XxxSvc), "YourTestNamePrefix");
			RegisterMyApi1(register);
			RegisterMyApi2(register);
			return Test;
		}
	}
	```

	`TestMyApi1.cs`
	```cs
	using Tsinswreng.CsTest;
	public partial class TestXxx{
		public ITestNode RegisterMyApi1(ITestFnRegister Register){
			var R = Register.Register;
			R("YourUniqName1", async(o)=>{
				//Test With Svc.MyApi1() here
				// arrange / act / assert
				return NIL;
			});

			R("YourUniqName2", async(o)=>{
				return NIL;
			});

			return Test;
		}
	}
	```
	
	`TestMyApi2.cs`
	```cs
	using Tsinswreng.CsTest;
	public partial class TestXxx{
		public ITestNode RegisterMyApi2(ITestFnRegister Register){
			var R = Register.Register;
			R("YourUniqName3", async(o)=>{
				//Test With Svc.MyApi2() here
				return NIL;
			});
			//...
			return Test;
		}
	}
	```

	這是新增測試類的首選模板。除非場景特殊, 否則不要自行發明另一套註冊方式。
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
]

#H[怎麼把測試類(Tester)註冊到 TestMgr][
	一個程序集(csproj)中只有一個 `TestMgr`
	新增完測試類後, *還必須註冊* 到對應的 TestMgr, 否則不會被執行。

	參考:
	- `Ngaq.Test/proj/Ngaq.Local.Test/LocalTestMgr.cs`
]

#H[怎麼收編子程序集(csproj)測試][
	如果是更上層的 TestMgr 
	不直接註冊每個測試類, 而是收編下級 TestMgr。

	參考:
	- `Ngaq.Test/proj/Ngaq.Windows.Test/WindowsTestMgr.cs`

	參考寫法:
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
]

#H[測試執行入口][
非必要 不需關心入口
]

#H[AI 新增測試時的最小操作清單][
	如果你是 AI, 當用戶要求“爲某個類補測試”時, 按這個順序做:
	+ 找到對應模塊下最近的測試目錄
	+ 新建 `TestXxx.cs`, 實現 `ITester`
	+ 在 `RegisterTestsInto` 中用 `MkFnRegisterTest` 註冊用例
	+ 在最近的 `TestMgr` 補 `RegisterTester<TestXxx>()`
	+ 若該模塊尚未被上層收編, 再補 `RegisterSubMgr(...)`
	+ 不看主入口, 除非用戶明確要求
]

#H[測試涉及數據庫操作的函數][
要先自行把測試數據插入數據庫、
注意構造的測試數據要構獨特、避免與其他已有數據重複
測試結束後(不管成功還是失敗)都要把插入的數據都刪除
]
