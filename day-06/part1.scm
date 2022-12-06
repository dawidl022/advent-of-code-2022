(define (!= x y)
    (not (equal? x y)))

(define (4-different a b c d) 
    (and (!= a b)
        (and (!= a c)
            (and (!= a d)
                (and (!= b c) 
                    (and (!= b d) (!= c d)))))))

(define (start-of-stream-index)
    (define (s-iter char1 char2 char3 char4 rest i)
        (if (4-different char1 char2 char3 char4)
            i
            (s-iter char2 char3 char4 (car rest) (cdr rest) (+ i 1))))
    (define (s-start l)
        (s-iter (car l) (cadr l) (caddr l) (cadddr l) (cddddr l) 4))
    (s-start (string->list (read-line))))

(start-of-stream-index)
