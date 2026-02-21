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
]

#H[代碼風格][
- 左大括號不換行
- 自定義的異步函數不加任何後綴、末參數聲明爲`CT Ct`即表示異步
- 除函數中的臨時變量外、所有標識符(包括函數參數)都用大駝峯! 首字母要大寫!
]

#H[AOT][
	*!!!所有代碼必須兼容AOT!!!*
	- 禁止使用一切不兼容AOT的反射, Emit等
	- 禁止在表達式樹外使用匿名對象
	- 禁止使用dynamic
]

#H[配置讀取示例][
```cs
using Tsinswreng.CsCfg;

void ReadCfg(
	ICfgAccessor Cfg
	,ICfgItem<str> Item
){
	str Value = Cfg.Get(Item);
}
```

]
