;;;; info.read-eval-print.lambda.lisp

(in-package #:info.read-eval-print.lambda)

(defmacro ^ (&body body)
  (let* ((syms (collect-argument-symbols body))
         (rest (find '_rest syms :key #'symbol-name :test #'string=)))
    (when rest
      (setq syms (append (remove rest syms) `(&rest ,rest))))
    (if (consp (car body))
        `(lambda ,syms
           ,@body)
        `(lambda ,syms
           ,body))))

(defun collect-argument-symbols (form)
  (collect-symbols form (lambda (x) (symbol-head-p x "_"))))

(defun symbol-head-p (symbol head)
  (and (symbolp symbol)
       (let ((p (mismatch (symbol-name symbol) head
                          :test #'char-equal)))
         (if p
             (= p (length head))
             t))))

(defun collect-symbols (form pred)
  (sort
   (remove-duplicates
    (collect
        (choose-if pred
                   (scan-lists-of-lists-fringe form))))
   #'string<=
   :key #'symbol-name))
