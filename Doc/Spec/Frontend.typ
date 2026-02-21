#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;
前端代碼規範
#H[項目技術棧][
- 語言C\#
- 平臺: .NET 10 AOT發佈(所有代碼必須兼容AOT)
- 框架: Avalonia (純C\# 不用Xaml)
]

#H[架構][
- MVVM模式
參考
- `Ngaq.Frontend/proj/Ngaq.Ui/CodeTemplate/Sample/*.cs`
- `Ngaq.Frontend/proj/Ngaq.Ui/Infra/ViewModelBase.cs`

這兩個是模板、你不用看、上面的Sample/已經包含了
- `Ngaq.Frontend/proj/Ngaq.Ui/CodeTemplate/ViewXxx.cs`
- `Ngaq.Frontend/proj/Ngaq.Ui/CodeTemplate/VmXxx.cs`
]
