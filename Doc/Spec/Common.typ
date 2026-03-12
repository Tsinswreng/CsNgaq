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

#H[xml文檔][
禁止寫 `/// <summary>` 和 `/// </summary>`  因爲太長了

錯誤示例
```cs
/// <summary>
/// This is a summary.
/// </summary>
public class MyClass {}
```

正確示例
```cs
/// This is a summary.
public class MyClass {}
```
]

#H[可迭代集合][
如果代碼中有 `IEnumerable<>`或`IAsyncEnumerable<>`
則默認是需要懶加載的

謹慎使用`.ToList()`或類似API 因爲這會把所有元素都載入內存!
]
