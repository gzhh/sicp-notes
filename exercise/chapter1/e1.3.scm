(define (e13 a b c)
	(cond ((and (< a b) (< a c)) (+ (* b b) (* c c)))
				((and (< b a) (< b c)) (+ (* a a) (* c c)))
				(else (+ (* a a) (* b b)))))

(e13 1 2 3)
(e13 3 2 1)
(e13 1 3 2)
