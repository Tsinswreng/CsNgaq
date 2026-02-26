#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

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
