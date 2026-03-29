#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;
前端代碼規範
#H[項目技術棧][
- 語言C\#
- 平臺: .NET 10 AOT發佈(所有代碼必須兼容AOT)
- 框架: Avalonia (純C\# 不用Xaml)
- UI工具庫: `<項目根目錄>/CsDeclOut/Tsinswreng.AvlnTools/`
- 因爲要一套UI同時兼容移動端平臺與桌面端平臺、所以所有UI佈局都按豎屏移動端的來做

]

#H[架構][
- MVVM模式
參考
- `Ngaq.Frontend/proj/Ngaq.Ui/CodeTemplate/Sample/**/*.cs`
- `Ngaq.Frontend/proj/Ngaq.Ui/Infra/ViewModelBase.cs`

這兩個是模板、你不用看、上面的Sample/已經包含了
- `Ngaq.Frontend/proj/Ngaq.Ui/CodeTemplate/ViewXxx.cs`
- `Ngaq.Frontend/proj/Ngaq.Ui/CodeTemplate/VmXxx.cs`
]


#H[UI設計風格][
	- 不要圓角
]

#H[常用工具][
帶標題修飾器:
`Ngaq.Frontend\proj\Ngaq.Ui\Tools\ToolView.cs`

#H[視圖導航][
用ViewModelBase的
```cs
public IViewNavi? ViewNavi{get;set;}
```
]
]

#H[UiCfg][
`Ngaq.Frontend\proj\Ngaq.Ui\UiCfg.cs`
內有字體大小, 主題色與窗口大小。
]


#H[字體大小設置][
	勿硬編碼字體大小
	應當用`UiCfg.Inst.BaseFontSize` 乘以一個系數
]

#H[AI調用後端接口的注意事項][
	當你正在做 純前端的任務時、你只需看用戶提供給你的接口文件即可
	不要翻閱實現的部分、節約token
]

#H[項目使用到的圖標][
	`Ngaq.Frontend/proj/Ngaq.Ui/Icons/Svgs.Decl.cs`
	禁止讀 Svgs.Impl.cs 文件! 否則會消耗大量token
]
