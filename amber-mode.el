;;; text
(require 'syntax)

(defconst amber--font-lock-defaults
  (let ((keywords '(    ;; Keyworks
                    "fun" "let" "return" "const" "ref" "pub" "import" "from" "main" "as"

                    ;; Conditional
                    "if" "else" "and" "not" "then"

                    ;; Commands
                    "fail" "failed" "trust" "silent"

                    ;; Loops
                    "loop" "for" "in" "break" "continue"

                    ;; Builtins
                    "echo" "cd" "len" "lines" "mv" "nameof"))
        (types '("Text" "Num" "Bool" "Null" "Int"))
        (const '("true" "false" "null")))
    `(((, (rx-to-string `(: (or ,@keywords))) 0 font-lock-keyword-face)
       ("\\([[:word:]]+\\)\s*(" 0 font-lock-function-name-face)
       (, (rx-to-string `(: (or ,@types))) 0 font-lock-type-face)
       (, (rx-to-string `(: (or ,@const))) 0 font-lock-constant-face)
       ))))

(defun amber-calculate-indentation ()
  "Return the column to which the current line should be indented."
  (* tab-width (min (car (syntax-ppss (line-beginning-position)))
                    (car (syntax-ppss (line-end-position))))))

(defun amber-indent-line ()
  "Indent current line."
  (interactive)
  (let ((savep (> (current-column) (current-indentation)))
        (indent (condition-case nil (max (amber-calculate-indentation) 0)
                  (error 0))))
    (if savep
        (save-excursion (indent-line-to indent))
      (indent-line-to indent))))

(defun amber-mode-syntax-table ()
  "Syntax table for `amber-mode'."
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?/ "." table)
    (modify-syntax-entry ?/ "." table)
    (modify-syntax-entry ?\n ">" table)

    (modify-syntax-entry ?\" "\"" table)
    (modify-syntax-entry ?\\ "\\" table)

    ;; Curly braces for interpolation
    (modify-syntax-entry ?{ "(}" table)
    (modify-syntax-entry ?} "){" table)

    (modify-syntax-entry ?$ "\"" table)
    table))

(define-derived-mode amber-mode prog-mode "Amber"
  "A major mode for the Amber programming language."
  :syntax-table (amber-mode-syntax-table)
  (setq-local comment-start "// ")
  (setq-local comment-start-skip "//+ *")
  (setq-local comment-end "")
  (setq buffer-file-coding-system 'utf-8-unix) ;; might be redundent
  (setq font-lock-defaults amber--font-lock-defaults)
  (setq-local indent-line-function 'amber-indent-line)
  (setq-local tab-width 4)
  (setq-local indent-tabs-mode t))

(add-to-list 'auto-mode-alist '("\\.ab\\'" . amber-mode))

(provide 'amber-mode)

;;; amber-mode.el ends here
