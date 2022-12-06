(define (!= x y)
    (not (equal? x y)))

(define (slice l start end)
    (define (slice-iter i curr rest result)
        (cond ((= i end) result)
            ((= 0 (length rest)) (append result (list curr)))
            ((< i start) (slice-iter (+ i 1) (car rest) (cdr rest) result))
            (else (slice-iter (+ i 1) (car rest) (cdr rest) (append result (list curr))))))
    (slice-iter 0 (car l) (cdr l) (list)))

(define (contains? item l)
    (cond ((= 0 (length l)) #f)
        ((equal? item (car l)) #t)
        (else (contains? item (cdr l)))))

(define (all-different l)
    (or (= 0 (length l))
        (and (not (contains? (car l) (cdr l))) (all-different (cdr l)))))

; very inefficient solution (O(n^2)), so may take up to minute to complete
(define (start-of-stream-index)
    (define (s-iter l i)
        (if (all-different (slice l i (+ i 14)))
            (+ i 14)
            (s-iter l (+ i 1))))
    (s-iter (string->list (read-line)) 0))

(start-of-stream-index)
