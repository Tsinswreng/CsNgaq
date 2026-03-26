#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

註釋內容的規範

不論註釋形式是普通註釋或是DocAttr的註釋 都適用本規則

#H[`[Doc]`用法][
	只用于 類型(interface/class/struct/enum 等等)/函數/成員、不適用于函數內的實現
	需要爲函數內的實現也加註釋時 使用 普通的雙斜槓註釋。
]

#H[甚麼地方要加註釋][
	AI生成的代碼、註釋要詳盡。
	
	- 在 類型/函數/成員 中 加 `[Doc]` 註釋
	- 在其他地方添加普通雙斜槓註釋。
]


- 大部分情況下 public的符號 都建議要加註釋。除非是代碼非常簡單且意圖顯而易見
- 註釋要避免正確廢話

錯誤示例:
```cs
public class Person{
	[Doc($@"Default ctor")]
	public Person(){

	}
}
```
誰都能一眼看出來`public Person()`是默認構造器、這種註釋毫無意義、所以應當避免。

- 註釋要多舉例子

除了類/函數上的註釋之外、函數實現中的註釋 該寫的也要寫

