#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;
#H[寫給AI的提示詞][
	如果你是AI、當你接收到任務、需要在源碼中補充`[Doc]`風格的文檔的時候:
	- 嚴格按照上面的說明執行
	- 如果源碼中已經有了xml風格的註釋、仍然要補充上`[Doc]`註釋。*原有的註釋不要刪。*
	- 大部分情況下 public的符號 都建議要加 `[Doc]`註釋。除非是代碼非常簡單且意圖顯而易見
	- 一次性多改點、不要每次就只改了一點東西就來找我確認
	- 註釋要避免正確廢話。
		錯誤示例:
		```cs
		public class Person{
			[Doc($@"Default ctor")]
			public Person(){

			}
		}
		```
		誰都能一眼看出來`public Person()`是默認構造器、這種註釋毫無意義、所以應當避免。

]
