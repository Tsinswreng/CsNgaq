#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;
\-\-\-

name: debug

description: 調試 debug。在代碼有問題時使用此skill、通常不需要在開發編碼階段使用此skill

\-\-\-


#H[流程][
	先肉眼看一遍代碼 看看能不能看出問題

	#H[若不能確定問題][
		可以嘗試在代碼中加入輸出語句
		如
		- 調用Logger
		- Console.WriteLine
		- 直接寫文件

		然後請示用戶再次運行程序看輸出
		
		若仍不能確定 則多加輸出語句 循環往復
	]

	#H[如果能確定問題][
		先向用戶分析、不要急着改代碼。分析完之後再請示用戶要不要改代碼 並說方案
	]


]

