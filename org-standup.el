;;; org-standup.el --- Manage daily standup notes in org-mode.  -*- lexical-binding: t; -*-

;; Copyright (C) 2017 hg-jt

;; Author: hg-jt <hg-jt@users.noreply.github.com>
;; Version: 0.2

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; org-standup provides utilities for managing daily standup notes in
;; org-mode.  Each day's standup notes are stored in a separate file in
;; a well defined directory hierarchy:
;;
;;  .
;;  └── yyyy
;;      └── mm
;;          ├── dd.org
;;          └── ...
;;
;; org-standup does not have any external package dependencies.
;;
;; Installation:
;;   M-x package-install-file <path to org-standup.el>
;;
;;
;; Configuration:
;;
;;  (add-hook 'after-init-hook
;;            (lambda ()
;;              ;; initialize the template
;;              (eval-after-load 'autoinsert (org-standup-template-init))
;;
;;              ;; enable auto-insert
;;              (add-hook 'find-file-hook 'auto-insert)))

;;; Code:
(defgroup org-standup nil
  "Options for managing daily standup notes."
  :group 'tools)


(defcustom org-standup-dir "~/daily-standup"
  "Base directory for storing daily standup entries."
  :group 'org-standup
  :type 'string)


(defcustom org-standup-title-format "%A, %B %e, %Y"
  "The format to use in new daily standup entries.

This value will be passed to `format-time-string'."
  :group 'org-standup
  :type 'string)


(defcustom org-standup-questions
  '("* What was accomplished yesterday?\n\n\n"
    "* What is your focus today?\n\n\n"
    "* What are you impediments/obstacles?\n\n")
  "A list of questions to include in the daily standup entry."
  :group 'org-standup
  :type 'list)


(defun org-standup--title-generator ()
  "Generate a title for a daily standup entry.

This function will attempt to extract date information from the
full path of the current file. If it is unable to extract the
date information, it will default to the current date."
  (let ((file-name (buffer-file-name)))
    (if (string-match
         (format  ; match the full path: ~/daily-standup/2017/08/21.org
          "^%s/\\([0-9]\\{4\\}\\)/\\([0-9]\\{2\\}\\)/\\([0-9]\\{2\\}\\).org"
          (expand-file-name org-standup-dir))
         file-name)
        (let ((year (match-string 1 file-name))
              (month (match-string 2 file-name))
              (day (match-string 3 file-name)))
          (format-time-string org-standup-title-format
                              (apply 'encode-time
                                     (parse-time-string
                                      ; include time to ease time encoding
                                      (format "%s-%s-%s 00:00" year month day)))))
      (format-time-string org-standup-title-format))) )


;;;###autoload
(defun org-standup-today ()
  "Create or open the daily standup entry for today."
  (interactive)
  (find-file (concat org-standup-dir (format-time-string "/%Y/%m/%d.org"))))


(defun org-standup-tomorrow ()
  "Create or open the daily standup for tomorrow."
  (interactive)
  (find-file (concat org-standup-dir
                     (format-time-string "/%Y/%m/%d.org"
                                         (time-add (current-time) 86400)))))


(defun org-standup-yesterday ()
  "Create or open the daily standup for yesterday."
  (interactive)
  (find-file (concat org-standup-dir
                     (format-time-string "/%Y/%m/%d.org"
                                         (time-subtract (current-time) 86400)))))

;;;###autoload
(defun org-standup-template-init ()
  "Initialize the daily standup entry template.

This function defines an `auto-insert' template for daily standup
entries. The template can be configured by customizing
`org-standup-title-format' and/or `org-standup-questions'."
  (define-auto-insert
    `(,(format "%s/[0-9]*/[0-9]*/[0-9]*\\.org" (expand-file-name org-standup-dir)) . "Daily Journal")
    (nconc '("Daily Journal"
             (concat "#+TITLE: " (org-standup--title-generator) "\n\n"))
           org-standup-questions))
  nil)


(provide 'org-standup)
;;; org-standup.el ends here
