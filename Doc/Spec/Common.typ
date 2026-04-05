#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

通用C\#代碼規範
#H[類型別名][
```cs
global using i32 = int;
global using str = string;
global using obj = object;
global using nil = object; // 專門用來表示null
global using CT = CancellationToken;
```

全局變量:`const nil NIL = null`
]

#H[異步函數規範][
	- 約定 最後一個參數聲明爲`CT Ct`的爲異步函數、不需要加`Async後綴`
	- 異步函數不返回值時、返回值聲明爲`Task<nil>`、不用無泛型的Task
	- 異步函數實現(有方法體的即函數實現)一定要加`async`
	正確示例: 
	```cs
	async Task<nil> WriteToFile(str FilePath, str Content, CT Ct){
		...
		return NIL;
	}
	```
]


#H[代碼風格][
- 左大括號不換行
- 除函數中的局部變量外、所有標識符(包括函數參數)都用大駝峯! 首字母要大寫!
]

#H[AOT][
	*!!!所有代碼必須兼容AOT!!!*
	- 禁止使用一切不兼容AOT的反射, Emit等
	- 禁止在表達式樹外使用匿名對象
	- 禁止使用dynamic
]

#H[目錄文檔][
	目錄下的`_.cs`的文件 作爲該目錄的文檔。描述該目錄或所屬模塊/領域的功能職責等。
	
	如果你的任務涉及到某些模塊、建議先閱讀裏面的說明㕥瞭解業務
	
	當你修改了模塊的代碼、需要同步更新文檔時、也寫進對應位置的`_.cs`裏
]


#H[可迭代集合][
如果代碼中有 `IEnumerable<>`或`IAsyncEnumerable<>`
則默認是需要懶加載的。

設計API旹優先接收`IAsyncEnumerable<>`。

對于可迭代聚合、謹慎使用`.ToList()`或類似API 因爲這會把所有元素都載入內存!
也不要自己foreach消費的時候自己開List積攢起來

需要操作內部元素旹盡量使用`.Select`保持懶加載

可迭代集合 只允許消費一遍!! 不允許多次消費！
]


#H[註釋][
	- 修改代碼時禁止刪除我已有的註釋
	- 新寫的代碼一定要多加註釋
	- 註釋要避免正確的廢話 不能只是把表面的流程和意思翻譯一遍
	
	類型(interface/class/struct/enum 等等)/函數/成員 及 函數內部的實現 都要寫註釋!!!
	
	#H[xml文檔註釋][
	禁止寫 `/// <summary>` 和 `/// </summary>`  因爲太長了。其他東西正常寫。
	]
	示例
	```cs
	/// 類型(interface/class/struct/enum)要寫註釋 不管是不是public的都要寫
	public class MyClass {
		/// 成員(field, prop 不管是不是public的)要有註釋
		public string Name{get;set;}
		/// 函數要寫註釋 不管是不是public的都要寫
		/// 函數的註釋至少要解釋 參數 返回值(除了CT之外)
		public Task<RespLogin> Login(ReqLogin Req, CT Ct){
			// 函數實現中該寫註釋的也要寫註釋
		}
	}
	```
]

#H[自研庫的文檔][
	對于自研庫(即命名空間以`Tsinswreng`開頭的)
	要開文檔優先看 `<項目根目錄>/CsDeclOut/`下的
	如非必要則禁止亂翻我的`<項目根目錄>/Tsinswreng.Xxx/`裏的源代碼!
]

#H[代碼架構規範][
	- 一個函數不要超過50行、若超過則考慮拆分
	- 函數不應接收過多參數。如果參數過多就應考慮建立專門的DTO作參數或返回值。
	- 使用面向接口的面向對象編程。用interface來做抽象而不是父類。
	- 僅用類繼承作爲代碼複用的手段、不依賴類繼承機制作抽象
	- 遵守SOLID原則
	- 考慮可擴展性和可維護性
	- 注意代碼複用、避免重複代碼。發現有能抽取複用邏輯時要抽取複用。
	- 禁止字符串硬編碼鍵名。禁止魔法字符串 魔法數字。 多用 nameof / 枚舉 / 自己實現枚舉
]
