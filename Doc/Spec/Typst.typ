#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

Typst 文檔書寫規範

標題用這種寫法:
#H[一級標題內容一][
	內容
	#H[二級標題內容][
		內容
	]
]
#H[一級標題內容二][
	內容
]
不要硬編碼標題序號。

錯誤示例:
#H[1. 概述][
	#H[1.1 開頭][

	]
]

正確示例:
#H[概述][
	#H[開頭][

	]
]

注意typst和markdown語法的區別。在typst中 加粗是一對星號、不是雙星號

井號是Typst關鍵字。在內容中表達普通井號時要反斜槓轉義。

