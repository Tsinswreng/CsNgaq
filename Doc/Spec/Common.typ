#let H(t,d)={}
通用C\#代碼規範
#H[類型別名][
```cs
global using i32 = int;
global using str = string;
global using obj = object;
global using CT = CancellationToken;
```
]

#H[代碼風格][
- 左大括號不換行
- 自定義的異步函數不加任何後綴、末參數聲明爲`CT Ct`即表示異步
- 除函數中的臨時變量外、所有標識符(包括函數參數)都用大駝峯
]

#H[AOT][
	*!!!所有代碼必須兼容AOT!!!*
]


#H[目錄描述][
	建議每個文件夾下都放一個`_.typ`文件來簡要描述該目錄。
]
