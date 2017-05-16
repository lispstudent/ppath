;;;; base.lisp
;; File containing common settings for all unit tests
;; 
(in-package :cl-user)
(defpackage pypath.test.base
  (:use :cl
        :prove)
  (:export testfile test-input random-shuffle random-shufflef))
   
(in-package :pypath.test.base)

;; turn off ansi colors in report output
(setf prove.color:*enable-colors* nil)
;; change type of the reporter to Test Anything Protocol
(setf prove:*default-reporter* :tap)

(defvar *test-data-path* (fad:merge-pathnames-as-directory (asdf:system-relative-pathname :pypath-test #P"t/") #P"data/"))

(defun testfile (filename)
  (merge-pathnames filename *test-data-path*))


(defmacro test-input (fun inp out)
  ;; example of generated code:
  ;; (is (py.path.details.nt::splitdrive "C:\\")
  ;;     '("C:" . "\\")
	;;   :test #'equal
  ;;     "Testing input: 'C:\\'"))
  (let ((inp-string
         (format nil "Testing input: ~s" inp)))
    (if (listp inp)
        `(is (apply #',fun ,inp)
             ,out
             :test #'equal
             ,inp-string)
        `(is (,fun ,inp)
             ,out
             :test #'equal
             ,inp-string))))


(defmethod random-shufflef ((container list))
  (let ((n (length container)))
    (loop for i from (- n 1) downto 0
          do 
          (rotatef (nth i container) (nth (random (+ i 1)) container)))
    container))


(defmethod random-shufflef ((container array))
  (let ((n (length container)))
    (loop for i from (- n 1) downto 0
          do 
          (rotatef (aref container i) (aref container (random (+ i 1)))))
    container))

(defmethod random-shuffle ((container list))
  (let ((result (copy-list container))
        (n (length container)))
    (loop for i from (- n 1) downto 0
          do 
          (rotatef (nth i result) (nth (random (+ i 1)) result)))
    result))


(defmethod random-shuffle ((container array))
  (let ((result (copy-seq container))
        (n (length container)))
    (loop for i from (- n 1) downto 0
          do 
          (rotatef (aref result i) (aref result (random (+ i 1)))))
    result))
