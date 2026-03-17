#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

註釋內容的規範

不論註釋形式是普通註釋或是DocAttr的註釋 都適用本規則

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
