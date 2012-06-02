#lang racket

(require rackunit)
(require "../src/line.rkt")
(require "../src/block.rkt")

;unit tests for block.rkt

(define/provide-test-suite test-block-IR?
  (test-case
   "Test block-IR?"
   (check-true (block-IR? null))
   (check-true (block-IR? (list null null)))
   (check-true (block-IR? (line #\a)))
   (check-true (block-IR? (list (line #\a #\b)
                                (line #\c 3))))
   (check-true (block-IR? (list (line #\a #\b)
                                (line #\c 3)
                                (line #\d 0))))
   (check-false (block-IR? (block)))
   (check-false (block-IR? 'other))))

(define/provide-test-suite test-block-input?
  (test-case
   "Test block-input?"
   (check-true (block-input? null))
   (check-true (block-input? (line #\a)))
   (check-true (block-input? (list (line #\a))))
   (check-true (block-input? (list (line #\a) (line #\b))))
   (check-true (block-input? (list (line #\a) (line #\b) (line #\c))))
   (check-true (block-input? (block (line #\a))))
   (check-true (block-input? (list (block (line #\a)))))
   (check-true (block-input? (list (block (line #\a)) (block (line #\b)))))
   (check-false (block-input? #\a))
   (check-false (block-input? "other"))))

(define/provide-test-suite test-block?
  (test-case
   "Test block?"
   (check-true (block? (block)))
   (check-true (block? (block null)))
   (check-true (block? (block (line #\a))))
   (check-true (block? (block (line #\a) (line #\b))))
   (check-true (block? (block (line #\a) (line #\b) (line #\c))))
   (check-false (block? (line #\a)))
   (check-false (block? 0))))

(define/provide-test-suite test-block
  (test-case
   "Test block"
   (check-true (block? (block)))
   (check-true (block? (block null)))
   (check-true (block? (block (line #\a))))
   (check-true (block? (block (line #\a) (line #\b))))
   (check-true (block? (block (block (line #\a)))))
   (check-equal? (block-IR (block (line #\a #\b #\c))) (list (line #\a #\b #\c)))))

(define/provide-test-suite test-block-IR
  (test-case
   "Test block-IR"
   (check-equal? (block-IR (block)) (line 0))
   (check-equal? (block-IR (block (line #\a)))
                 (list (line #\a)))
   (check-equal? (block-IR (block (line #\a) (line #\b)))
                 (list (line #\b) (line #\a)))
   (check-equal? (block-IR (block (line #\a) (line #\b) (line #\c)))
                 (list (line #\c) (line #\b) (line #\a)))
   (check-equal? (block-IR (block (line #\a) (line #\b) (block (line #\c))))
                 (list (line #\c) (line #\b) (line #\a)))))

(define/provide-test-suite test-build-block-IR
  (test-case
   "Test-case"
   (check-equal? (build-block-IR) (line))
   (check-equal? (build-block-IR null) (line))
   (check-equal? (build-block-IR (list null null)) (line))
   (check-equal? (build-block-IR (line #\a))
                 (list (line #\a)))
   (check-equal? (build-block-IR (line #\a) (line #\b))
                 (list (line #\b) (line #\a)))
   (check-equal? (build-block-IR (line #\a) (line #\b) (line #\c))
                 (list (line #\c) (line #\b) (line #\a)))))