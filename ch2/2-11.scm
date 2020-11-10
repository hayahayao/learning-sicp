;from http://community.schemewiki.org/?sicp-ex-2.11

;考虑 x1 x2 y1 y2 的正负，有以下情况（x1<x2, y1<y2）
; x1x2y1y2 |  min  |  max
; + + + +  | x1 y1 | x2 y2
; + + - +  | x2 y1 | x2 y2
; + + - -  | x2 y1 | x1 y2
; - + + +  | x1 y2 | x2 y2
; - + - +  | trouble case
; - + - -  | x2 y1 | x1 y1
; - - + +  | x1 y2 | x2 y1
; - - - +  | x1 y2 | x1 y1
; - - - -  | x2 y2 | x1 y1

;所以只有 - + - + 这种情况需要调用原来的 mul-interval 进行四次乘法再比较，其他的都一次直接出结果..
;代码不写了..
