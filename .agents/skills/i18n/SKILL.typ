#if false{
	[不需要生成markdown格式的skill。不需要安裝此skill。
	安裝的skill即使未使用、元數據也會發給llm 消耗詞元。
	]
}
#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;
\-\-\-

name: i18n

description: 多語言本地化/國際化(i18n)指南。僅當用戶明確要求你做多語言本地化時才需要參考、否則直接用Todo.I18n()

\-\-\-

#H[簡介][
	本文檔基於項目現有的 i18n 基礎設施編寫，說明如何添加新的多語言文本、支持新語言以及在 C\# 代碼中使用。
]

#H[i18n 譯文 json生成流程][
	#H[TS鍵結構定義][
		Ngaq.Frontend/I18n/keys.ts
	]
	#H[具體語言翻譯][
		如 `Ngaq.Frontend/I18n/langs/en-US.ts`
	]
	#H[具體語言註冊][
		`Ngaq.Frontend/I18n/main.ts`
		如
		```ts
		import en_US from "./langs/en-US"
		R("en_US", en_US)

		import zh_TW from "./langs/zh-TW"
		R("zh-TW", zh_TW)
		```
	]
	#H[執行生成腳本][
		*這條不用你做。我自己手動做。*
	]
]

#H[國際化鍵的定義][
	#H[TS側的鍵定義][
`Ngaq.Frontend/I18n/keys.ts`:

```ts
type Full = {
	//UI層顯示的文本
	View:{
		Common:{
			Confirm: K
			Cancel: K
		}
		About:{
			AppVersion:K
			//...
		}
	}
	//異常鍵翻譯
	Error:{
		Common: {
			ArgErr: K
			UnknownErr: K
		}
		User: {
			//...
		}
	}
	//語言名稱本身的翻譯
	Lang:{
		zh: K
		zh_CN: K
		//...
	}
}
```
	]
	
	#H[鍵格式與譯文格式][
		#H[譯文格式][
			使用 ICU MessageFormat 格式。 僅支持數字參數 如 `{0}` `{1}`、不支持名稱參數！
			
			參數後面可做條件判斷
			
			示例:
			```cs
			var pattern = "there are {0, plural, =0 {zero} =1 {one} =2 {two} other {#}}"
			```
			- `are` 後面的`0` 代表這是0號參數
			- plural 表示一種選擇模式
			- `=0{zero}` 即 `if(arg==0){return "zero";}`
			- `other{#}` 即 `else{return arg;}`
		]

約定 連續的兩個下劃線 表示參數佔位符
如
:
- 鍵定義: `Select__From__:K`
- 翻譯(zh-TW): `Select__From__: '從{1}選取{0}'`
- 翻譯(en): `Select__From__: 'select {0} from {1}'`
	約定 參數的順序和*鍵定義的標識符*的順序一致。
	
	例: en: `From__Select__: 'select {1} from {0}'`
	
	葉子節點的鍵格式最好接近英文版的譯文。
	]

	#H[C\# 側的鍵定義][
		#H[View][
```cs
namespace Ngaq.Ui.Infra.I18n;
using static Ngaq.Ui.Infra.I18n.I18nKey;
using K = II18nKey;

[Doc(@$"僅定義Ngaq.Ui 界面上的文字。
如需定義異常鍵 移步 {nameof(KeysErr)}。
")]
public static partial class KeysUiI18n{
	//只定義View、不要定義Lang和Error
	public static K? View = Mk(null, [nameof(View)]);
	

public class Common{
	public static readonly K _R = Mk(View, [nameof(Common)]);
	public static readonly K Confirm = Mk(_R, [nameof(Confirm)]);
	public static readonly K Cancel = Mk(_R, [nameof(Cancel)]);
}

//...
public class About{
	public static readonly K _R = Mk(View, [nameof(About)]);
	public static readonly K AppVersion = Mk(_R, [nameof(AppVersion)]);
	//...
}

}

```
		]
		#H[Error][
			看
			Ngaq.Core/Infra/Errors/KeysErr.cs
			
			結構類似。
		]
		#H[Lang][
			C\#側的 Lang 鍵先不用寫。 只在ts側寫好就行。
		]
	]
	
	注意: TS側的鍵路徑必須與C\#側的對應、否則生成的JSON路徑將不匹配，導致C\#側無法正確取值。
]


 //TODO ICU MessageFormat
#H[在 C\# 代碼中使用 i18 n][
	任何繼承自 `AppViewBase` 的視圖都自動擁有 `I` 屬性(類型 `II18n`)。
	你也可以用 `AppI18n.Inst` 全局變量獲取
	
	建議爲內部類鍵節點建立別名來縮短代碼
	如
	```cs
	using K = Ngaq.Ui.Infra.I18n.KeysUiI18n.Common;
	
	var userName = I[K.UserName]; //不需要傳參數時直接用[]
	var exampleWithArg = I.Get(K.__CannotBeEmpty, "User Name"); //需要傳參數時纔用Get
	```


	#H[錯誤碼自動轉換][
		項目中 `IErrNode` 擴展方法 `ToI18nKey()` 可將錯誤節點轉換爲 `I18nKey`，路徑前綴爲 `Error`。例如錯誤路徑 `["User", "UserNotExist"]` 會映射到 JSON 中的 `Error.User.UserNotExist`。
	]

]

#H[臨時硬編碼][
	用`Todo.I18n("xxx")`標句 待 翻譯處。
	
	如 `Button.Content = Todo.I18n("登錄");`
]

#H[最後再強調幾點要求][
	#H[鍵格式要接近英文譯文][]
	#H[View/下的鍵的層級劃分][
		僅對于`View/`:
		絕大多數情況 你只需要放在 `Common/`下。
		因爲鍵名相同、代表譯文也應當相同。
		如果遇到鍵名相同但希望區分不同譯文的情況、那應該避免使用相同的鍵名。
		
		但是`Error/`的異常鍵枚舉還是要按領域劃分、不能全放common下。
		
		例
		```ts
		View{
			Common{
				//都寫在這裏即可
			}
			//這裏不需要再創建其他節點
		}
		Error{
			//裏面的異常鍵要按領域劃分、不能全放common下
			User{
				//...
			}
			Word{
				...
			}
		}
		```
	]
	#H[在C\#中調用時須盡量使代碼簡短][
		#H[正確示例][
			```cs
			using K = Ngaq.Ui.Infra.I18n.KeysUiI18n.Common;
			var userName = I[K.UserName];
			```
			
		]
		#H[錯誤示例][
			```cs
			var userName = I18n[KeysUiI18n.LoginRegister];
			```
		]
		
	]
]
