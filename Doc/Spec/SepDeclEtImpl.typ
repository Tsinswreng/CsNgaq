#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

#H[聲明與實現分離][
	我們鼓勵聲明與實現分離。
	這樣、他方(如AI)閱讀已有API修改代碼時、可直接查看聲明 而無需管實現、節約Token。
	
	#H[具體做法][
		#H[基于接口的聲明與實現分離][
			非常典型且常見的做法。把聲明寫在interface裏、實現寫在class裏。
			調用方只用看interface中的簽名、一般配合依賴注入系統一起用、把interface注入後即能直接使用、無需管實現。
			
			#H[文件命名規則][
				一般建議接口文件和實現類文件分開。接口有`I`前綴。
			]
		]
		#H[基于分部方法的 聲明與實現分離][
			使用 `partial` 關鍵字。
			例:
			
			`MainView.Decl.cs`:
			```cs
			public partial class MainView{
				[Doc(@$"可關閉彈窗")]
				public partial nil ShowDialog(str Msg);
			}
			```
			`MainView.Impl.cs`
			```cs
			public partial class MainView{
				[Doc(@$"可關閉彈窗")]
				public partial nil ShowDialog(str Msg){
					//這裏放方法的具體實現
					return NIL;
				}
			}
			```
			#H[文件命名規則][
				
			]
		]
	]
]
