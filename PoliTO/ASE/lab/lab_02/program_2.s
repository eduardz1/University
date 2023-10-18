; ******** winMIPS64 **********
; Program that computes the output y of a neural computation
; formalized by the following equation:
; x = sum_{i=0}^{k-1} (i_j * w_j + b)
; y = f(x)
; 
; where, to prevent the propagation of NaN (Not a Number)
; the activation function f is defined as follows:
; f(x) = 0 if the exponent part of x is equal to 0x7ff
;        x otherwise